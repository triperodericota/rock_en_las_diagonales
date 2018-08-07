class State < ApplicationRecord

  has_many :order_states
  has_many :orders, through: :order_states

end
