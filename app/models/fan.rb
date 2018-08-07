class Fan < ApplicationRecord

  has_one :user, as: :profile, dependent: :destroy
  accepts_nested_attributes_for :user
  has_and_belongs_to_many :artists
  has_many :audiences
  has_many :events, through: :audiences
  has_many :orders

  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }

  def following?(anArtist)
    self.artists.include? anArtist
  end

  def is_assistant_for?(anEvent)
    self.events.include? anEvent
  end

  def next_events
    # includes current events
    self.events.where("start_date >= :current
      OR start_date <= :current AND end_date >= :current", {current: DateTime.current})
  end

  def past_events
    self.events.where("end_date < ?" , DateTime.current)
  end

end
