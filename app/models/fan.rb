class Fan < ApplicationRecord

  has_one :users, as: :profile

  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }

end
