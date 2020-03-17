class Order < ApplicationRecord

  belongs_to :product
  belongs_to :fan
  belongs_to :buyer
  belongs_to :state
  has_many :order_states
  has_many :states, through: :order_states
  belongs_to :address

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

  def create_checkout
    @preferenceData = {
        "items": [ self.product.hash_data_for_order(self.units) ],
        "payer": self.buyer.hash_data_for_order,
        "back_urls": {
            "success": "https://localhost:3000/fans/#{current_user.profile.id}/my_purchases",
            "pending": "https://localhost:3000/fans/#{current_user.profile.id}/my_purchases",
            "failure": "http://localhost:3000/artists/#{self.artist.name}/products/#{self.id}"
        },
        "auto_return": "approved"
    }
    add_address_data_to(@preferenceData)
    preference = $mp.create_preference(@preferenceData)
    self.preference_id = preference["response"]["id"]
    self.save
    preference
  end

  protected

  def add_address_data_to(data_hash)
    self.address.hash_data_for_order(data_hash) unless self.address.nil?
  end

end
