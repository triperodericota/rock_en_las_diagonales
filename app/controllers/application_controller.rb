class ApplicationController < ActionController::Base

  protect_from_forgery prepend: true, with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user|
        if params[:user][:fan]
          user.permit(:email, :password, :password_confirmation, :username, :user_type, fan: [:first_name, :last_name])
        elsif params[:user][:artist]
            user.permit(:email, :password, :password_confirmation, :username, :user_type, artist: [:name, :description])
        end
#          extra_params = extra_params.each {|param| param.to_s.to_sym }
#          type = "#{type}_attributes"
#          extra_params = { type => extra_params }
#          logger.debug "type = #{type}"
#          logger.debug "extra_params= #{extra_params}"
      end
  end

  protected

    def authenticate_fan!
      redirect_to(new_user_session_path) unless current_user.profile_type == "Fan"
    end

    def authenticate_artist!
      redirect_to(new_user_session_path) unless current_user.profile_type == "Artist"
    end

    def set_artist
      @artist = current_user.profile
    end

end
