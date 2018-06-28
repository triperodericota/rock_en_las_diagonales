class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  belongs_to :profile, polymorphic: true
  validates_associated :profile
  validates :username, presence: true, length: { maximum: 20 }, uniqueness: true

  def fan?
    self.profile_type ==  "Fan"
  end

  def artist?
    self.profile_type == "Artist"
  end


end