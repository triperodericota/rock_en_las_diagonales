module ApplicationHelper

 # helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def user_image_path(anUser)
    anUser.photo.user_mini.url || anUser.photo.url
  end

end

