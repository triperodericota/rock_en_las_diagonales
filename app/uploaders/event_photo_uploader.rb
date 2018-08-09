class EventPhotoUploader < PhotoUploader

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    ActionController::Base.helpers.asset_path('default_event_picture.png')
  end

end