class Order < ApplicationRecord

  belongs_to :product
  belongs_to :fan
  belongs_to :buyer
  belongs_to :state
  has_many :order_states
  has_many :states, through: :order_states

  validates_associated :product, :fan, :state, :buyer
  validates :units, presence: true, length: { maximum: 10 }, numericality: { only_integer: true , greater_than_or_equal_to: 1 }
  validates :total_price, presence: true, length: { maximum: 10 }, numericality: { greater_than_or_equal_to: 0 }

  before_validation do |order|
    order.total_price= (order.product.price * order.units)
    order.state= State.find_by(name: 'Abierta')
  end

  def cancelled
    self.current_state.cancel
  end

  def accepted
    self.current_state.accept
  end


end
