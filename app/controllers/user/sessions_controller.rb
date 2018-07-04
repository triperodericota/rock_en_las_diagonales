# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /user/sign_in
   def new
     # redirect to welcome#index because here exist the unique login form
     redirect_to root_path
   end

   # POST /user/sign_in
   def create
     user = User.find_by(email: sign_in_params[:email])
     if user
       if user.valid_password? sign_in_params[:password]
         set_flash_message!(:notice, :signed_in)
         sign_in(resource_name, user)
         redirect_to root_url
       else
         flash[:error] = 'La contraseña es incorrecta'
         redirect_to root_url
       end
     else
       flash[:error] = 'La contraseña y/o email ingresados son incorrectos'
       redirect_to root_url
     end
   end

   # DELETE /user/sign_out
   def destroy
     super
   end

   protected

   # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

end
