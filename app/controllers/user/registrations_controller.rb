# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController

   before_action :configure_sign_up_params, only: [:create]
   before_action :configure_account_update_params, only: [:update]

   #  GET /user/sign_up or /sign_up/(:type)
   def new
     user_param = request.path_parameters[:type]
     if user_param.nil? || !(["fan","artist"].include? user_param )
       @user_type = "fan"
     else
       @user_type = user_param.html_safe
     end
     super
   end

   # POST /user
   def create
     user_params = sign_up_params
     #take out user_type from user_params
     @user_type = user_params.delete (:user_type)
     #obtain a nested hash (:fan or :artist)
     child_class_params = user_params.delete (@user_type.to_s.underscore.to_sym)

     build_resource(user_params)
     # crate a new child instance depending on the given user type
     child_class = @user_type.camelize.constantize
     user_profile = child_class.new(child_class_params.symbolize_keys)
     resource.profile = user_profile

     resource.save
     user_profile.save
     yield resource if block_given?
     if resource.persisted? && user_profile.persisted?
       if resource.active_for_authentication?
         set_flash_message! :notice, :signed_up
         sign_in(resource_name, resource)
         respond_with resource, location: after_sign_up_path_for(resource)
       else
         set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
         expire_session_data_after_sign_in!
         respond_with resource, location: after_inactive_sign_up_path_for(resource)
       end
     else
       clean_up_passwords(resource)
       set_minimum_password_length
       respond_with resource
     end
   end

   # GET /user/edit
   def edit
     super
   end

   # PUT /resource
   def update
     self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
     prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

     user_params = account_update_params
     user_params[:photo] = params[:photo]
     user_profile = current_user.profile_type.underscore
     user_type_params = user_params.delete(user_profile)

     profile_updated = resource.profile.update(user_type_params)
     resource_updated = update_resource(resource, user_params)

     yield resource if block_given?
     if resource_updated && profile_updated
       if is_flashing_format?
         flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
                         :update_needs_confirmation : :updated
         set_flash_message :notice, flash_key
       end
       bypass_sign_in resource, scope: resource_name
       respond_with resource, location: after_update_path_for(resource)
     else
       clean_up_passwords resource
       set_minimum_password_length
       respond_with resource
     end
   end

   # DELETE /user
   def destroy
     super
   end

   # GET /resource/cancel
   # Forces the session data which is usually expired after sign
   # in to be expired now. This is useful if the user wants to
   # cancel oauth signing in/up in the middle of the process,
   # removing all OAuth session data.
   def cancel
     super
   end

   protected

   # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up) do |user|
       if params[:user][:fan]
         user.permit(:email, :password, :password_confirmation, :username, :user_type, fan: [:first_name, :last_name])
       elsif params[:user][:artist]
         user.permit(:email, :password, :password_confirmation, :username, :user_type, artist: [:name, :description])
       end
     end
   end

  #  If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
     if current_user.fan?
       devise_parameter_sanitizer.permit(:account_update, keys: [:username, :photo, fan: [:first_name, :last_name]])
     else
       devise_parameter_sanitizer.permit(:account_update, keys: [:username, :photo, artist: [:name, :description]])
     end

   end

  #  The path used after sign up.
   def after_sign_up_path_for(resource)
     after_sign_in_path_for(resource)
   end

   #  The path used after sign up for inactive accounts.
   def after_inactive_sign_up_path_for(resource)
     super(resource)
   end
end
