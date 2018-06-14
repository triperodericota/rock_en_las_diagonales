class Fan < ApplicationRecord

  has_one :user, as: :profile, dependent: :destroy
  accepts_nested_attributes_for :user

  validates :first_name, precense: true, length: { maximum: 25 }
  validates :last_name, precense: true, length: { maximum: 25 }

end
