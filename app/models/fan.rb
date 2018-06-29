class Fan < ApplicationRecord

  has_one :user, as: :profile, dependent: :destroy
  accepts_nested_attributes_for :user
  has_and_belongs_to_many :artists

  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }

  def following?(anArtist)
    self.artists.include? anArtist
  end

end
