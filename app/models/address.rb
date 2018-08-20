class Address < ApplicationRecord

  belongs_to :buyer

  validates_associated :buyer
  validates :state, presence: true, length: { maximum: 40 }
  validates :city, presence: true, length: { maximum: 40 }
  validates :street_name, presence: true, length: { maximum: 25 }
  validates :street_number, presence: true, length: { maximum: 40 }
  validates :zip, presence: true, length: { maximum: 5 }
  validates :state, length: { maximum: 5 }

  def to_s
    s = "#{self.state.humanize}, #{self.city.humanize}. Calle #{self.street_name.humanize}, número #{self.street_number}"
    s << ",dpto #{self.apartament}" unless self.apartament.nil?
    s
  end

end
