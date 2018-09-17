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

  def check_address(address_params)
    # check if user load fields for home delivery
    if self.address.nil? && address_params.except(:apartament).values.all? {|v| !v.blank? }
      @address = Address.new(address_params)
      if @address.save
        self.address = @address
        correct_address = true
      else
        correct_address = false
      end
    else
      # without address for home delivery
      correct_address = true
    end
  end

  def hash_data_for_order
    data_hash = { "name": self.name,
        "surname": self.surname,
        "email": self.email,
        "date_created": DateTime.current,
        "phone": {
            "area_code": self.phone_cod_area,
            "number": self.phone_number
        },
        "identification":
            {  "type": "DNI",
               "number": self.dni,
            },

    }
    self.add_address_data_to(data_hash)
  end

  protected

  def add_address_data_to(data_hash)
    unless self.address.nil?
      data_hash["address"] =
          {   "street_name": self.address.street_name,
              "street_number": self.address.street_number,
              "zip_code": self.address.zip
          }
    end
  end

end
