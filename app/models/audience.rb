class Audience < ApplicationRecord
  belongs_to :event
  belongs_to :fan
end
