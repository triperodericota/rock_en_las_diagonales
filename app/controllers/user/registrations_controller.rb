# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController

   before_action :configure_sign_up_params, only: [:create]
   before_action :configure_account_update_params, only: [:update]

   #  GET /resource/sign_up
   def new
     super
   end

   # POST /resource
   def create

     user_params        = sign_up_params # is sign_up_params not able to edit?
     user_type          = user_params.delete (:user_type) #take out user_type from user_params
     child_class_params = user_params.delete (user_type.to_s.underscore.to_sym) #obtain a nested hash (:company or :client)

     logger.debug "sign_up_params: #{sign_up_params}"         #DEBUG
     logger.debug "user_params: #{user_params}"               #DEBUG
     logger.debug "user_type: #{user_type}"                   #DEBUG
     logger.debug "child_class_params: #{child_class_params}" #DEBUG

     build_resource(user_params)

     # customized code begin

     # crate a new child instance depending on the given users type
     child_class = user_type.camelize.constantize
     resource.profile = child_class.new(child_class_params.symbolize_keys)

     # first check if child instance is valid
     # cause if so and the parent instance is valid as well
     # it's all being saved at once
     valid = resource.valid?
     valid = resource.profile.valid? && valid

     # customized code end
       if valid && resource.save    # customized code
         yield resource if block_given?
         if resource.persisted?
           if resource.active_for_authentication?
             set_flash_message :notice, :signed_up if is_flashing_format?
             sign_in(resource_name, resource)
             respond_with resource, location: after_sign_up_path_for(resource)
           else
             set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
             expire_session_data_after_sign_in!
             respond_with resource, location: after_inactive_sign_up_path_for(resource)
           end
         else
           clean_up_passwords(resource)
           set_minimum_password_length
           #respond_with resource
           redirect_to action: 'new', :user_type => user_type
         end
       end
   end

   # GET /resource/edit
   def edit
     super
   end

   # PUT /resource
   def update
     super
   end

   # DELETE /resource
   def destroy
     super
   end

   # GET /resource/cancel
   # Forces the session data which is usually expired after sign
   # in to be expired now. This is useful if the users wants to
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
     devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
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
