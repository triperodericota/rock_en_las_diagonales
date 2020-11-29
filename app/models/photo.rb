class Photo < ApplicationRecord

  belongs_to :product
  mount_uploader :image, PhotoUploader

end
