class Payment < ApplicationRecord

  belongs_to :order

  validates_associated :order
  validates :status, presence: true, length: { maximum: 50 }
  validates :payment_type, presence: true, length: { maximum: 50 }
  validates :merchant_order_id, presence: true, numericality: { only_integer: true }
  validates :mercadopago_payment_id, presence: true, numericality: { only_integer: true }

  def approved?
    self.status == "approved"
  end

  def rejected?
    self.status == "rejected"
  end

  def pending?
    self.status == "pending"
  end



end
