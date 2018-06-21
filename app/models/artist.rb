class Artist < ApplicationRecord

  has_one :users, as: :profile
#  attr_accessor :users
#  accepts_nested_attributes_for :users

  validates :name, length: { maximum: 30 }, presence: true, uniqueness: true


  def to_param
    name
  end

end
