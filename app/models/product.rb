class Product < ApplicationRecord

  belongs_to :artist
  has_many :orders
  has_many :photos, :dependent => :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  validates_associated :artist
  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true, length: { maximum: 10 }, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, length: { maximum: 10 }, numericality: { only_integer: true , greater_than_or_equal_to: 0 }

  def report_stock
    return "#{self.stock} unidad/es disponibles" if self.in_stock?
    'Por el momento no se dispone de stock'
  end

  def in_stock?
    self.stock > 0
  end

  def stock_greater_or_equals_than?(aNumber)
    self.stock >= aNumber
  end

  def amount_of_sales
    self.orders.size
  end

  def main_photo
    begin
      return self.photos.first.image.url
    rescue
      ActionController::Base.helpers.asset_path('default_product_photo.gif')
    end
  end

end



