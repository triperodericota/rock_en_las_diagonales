class Buyer < ApplicationRecord

  has_many :orders
  has_one :address

  validates :name, presence: true, length: { maximum: 30 }
  validates :surname, presence: true, length: { maximum: 30 }
  validates :dni, presence: true, length: { maximum: 8 }, numericality: { only_integer: true }, uniqueness: true
  validates :phone, length: { maximum: 14 }

  before_validation do |buyer|
    buyer.phone_number = buyer.phone.last(7)
    buyer.phone_cod_area = buyer.phone.first(4)
  end

end
