class Address < ApplicationRecord

  has_many :orders
  has_and_belongs_to_many :buyers

  validates :state, presence: true, length: { maximum: 40 }
  validates :city, presence: true, length: { maximum: 40 }
  validates :street_name, presence: true, length: { maximum: 25 }
  validates :street_number, presence: true, length: { maximum: 40 }
  validates :zip, presence: true, length: { maximum: 5 }
  validates :apartament, length: { maximum: 5 }

  def to_s
    s = "#{self.state.humanize}, #{self.city.humanize}. Calle #{self.street_name.humanize}, número #{self.street_number}"
    s << ",dpto #{self.apartament}" unless self.apartament.nil?
    s
  end

  def hash_data_for_order(data_hash)
    data_hash["payer"]["address"] =
        {   "street_name": self.address.street_name,
            "street_number": self.address.street_number,
            "zip_code": self.address.zip
        }
  end

end
