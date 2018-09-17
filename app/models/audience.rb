class Audience < ApplicationRecord
  belongs_to :event
  belongs_to :fan

  scope :popular_events, -> { group("event_id").count.to_a.sort {|event1, event2| event2.second <=> event1.second}.take(3) }

end
