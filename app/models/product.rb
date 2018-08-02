class Product < ApplicationRecord

  belongs_to :artist
  has_many :purchases
  has_many :photos, :dependent => :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  validates_associated :artist
  validates :title, presence: true, length: { maximum: 30 }
  validates :price, presence: true, length: { maximum: 10 }, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, length: { maximum: 10 }, numericality: { only_integer: true , greater_than: 0 }


  def report_stock
    return self.stock if self.in_stock?
    'Por el momento no se dispone de stock'
  end

  def in_stock?
    self.stock > 0
  end

  def stock_greater_than?(aNumber)

  end

  def amount_of_sales

  end

end



