class Event < ApplicationRecord

  belongs_to :artist
  has_many :audiences
  has_many :fans, through: :audiences
  mount_uploader :photo, EventPhotoUploader

  validate :start_date_should_be_earlier_than_end_date
  validates_associated :artist
  validates :title, presence: true, length: { maximum: 40 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  def start_date_should_be_earlier_than_end_date
    if end_date <= start_date
      errors.add(:end_date, "no puede ser anterior o igual a la fecha y hora de inicio")
    end
  end

  def finished?
    self.end_date < DateTime.current
  end

  def currently?
    DateTime.current.between?(self.start_date, self.end_date)
  end

  def audience_amount
    self.fans.size
  end

  def is_favourite_for?(aFan)
    self.fans.include? aFan
  end

  def how_much_time_is_left_to_start
    return "Evento finalizado" if self.finished?
    return "Evento en curso" if self.currently?
    how_much_time = ActiveSupport::Duration.build(self.start_date - DateTime.current)
    return create_string_response(how_much_time)
  end

  private

  def create_string_response(aDuration)
    string = "Faltan "
    traduction =  {:years => 'años', :months => 'meses', :weeks => 'semanas', :days => 'días', :hours => 'horas', :minutes => 'minutos'}
    aDuration.parts.delete(:seconds)
    aDuration.parts.each_pair do |unit_time, amount|
      string << "#{amount.to_s} " << "#{traduction[unit_time]}, "
      string.gsub!(traduction[unit_time],traduction[unit_time].singularize) if amount.equal? 1
    end
    string << "para el comienzo del evento"
    string.gsub!(/,\s(\d+)\s(\w+), para /) do |s|
      s.delete! ','
      s.prepend ' y'
      s.delete! ','
      p s
    end
  end

end
