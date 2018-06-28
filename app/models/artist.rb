class Artist < ApplicationRecord

  has_one :user, as: :profile, dependent: :destroy
  accepts_nested_attributes_for :user
  has_and_belongs_to_many :fans

  validates :name, length: { maximum: 30 }, presence: true, uniqueness: true

  def to_param
    name
  end

  def amount_of_followers

  end

  def is_followed_for?(aFan)

  end

end
