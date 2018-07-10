class Event < ApplicationRecord

  belongs_to :artist
  has_many :audiences
  has_many :fans, through: :audiences

  validate :start_date_should_be_earlier_than_end_date
  validates_associated :artist
  validates :title, presence: true, length: { maximum: 40 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  def start_date_should_be_earlier_than_end_date
    if end_date <= start_date
      errors.add(:end_date, "end_date can't be earlier than start_date")
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
    traduction =  {:years => 'años', :months => 'meses', :days => 'días', :hours => 'horas', :minutes => 'minutos'}
    aDuration.parts.delete(:seconds)
    p aDuration
    aDuration.parts.each_pair do |unit_time, amount|
      puts "unit_time = #{unit_time}"
      puts "amount = #{amount}"
      string << "#{amount.to_s} " << "#{traduction[unit_time]},"
    end
    string << " para el comienzo del evento"
    p string
    str_match = string.split(/,(\d+)\s(\w+),/)
    p str_match
  end

end
