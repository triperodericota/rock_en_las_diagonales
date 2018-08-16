class Address < ApplicationRecord

  belongs_to :buyer

  validates_associated :buyer

  def to_s
    s = "#{self.state.humanize}, #{self.city.humanize}. Calle #{self.street_name.humanize}, número #{self.street_number}"
    s << ",dpto #{self.apartament}" unless self.apartament.nil?
    s
  end

end
