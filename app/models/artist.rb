class Artist < ApplicationRecord

  has_one :user, as: :profile, dependent: :destroy
  accepts_nested_attributes_for :user

  validates :name, length: { maximum: 30 }, presence: true, uniqness: true


end
