class Product < ApplicationRecord

  include Rails.application.routes.url_helpers

  belongs_to :artist
  has_many :orders
  has_many :photos, :dependent => :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  validates_associated :artist
  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true, length: { maximum: 10 }, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, length: { maximum: 10 }, numericality: { only_integer: true , greater_than_or_equal_to: 0 }

  scope :with_search_title, -> (search_title) {where ("title LIKE ?"), search_title}

  def to_s
    self.title
  end

  def base_uri
    artist_product_path(self.artist.name, self.id)
  end

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

  def update_stock_after_new_order(units_order)
    self.update(stock: self.stock - units_order)
  end

  def main_photo
    begin
      self.photos.first.image.url
    rescue
      return ActionController::Base.helpers.asset_path('default_product_photo.gif')
    end
  end

  def hash_data_for_order(units)
    { "id": self.id,
      "title": self.title,
      "quantity": units,
      "unit_price": self.price.to_f,
      "description": self.description,
      "currency_id":"ARS"
    }
  end

end



