require 'test_helper'

class FanTest < ActiveSupport::TestCase

  setup do
    @fan1 = fans(:fan1)
    @fan2 = fans(:fan2)
    @fan1.artists << artists(:artist1)
    @fan2.artists << artists(:artist2)
  end

  test "should valid following an artist" do
    assert @fan1.following? artists(:artist1)
    assert_not @fan1.following? artists(:artist2)
  end

  test "should valid is assistant for an event" do
    assert @fan1.is_assistant_for? events(:event1)
    assert_not @fan2.is_assistant_for? events(:event2)
  end

  test "should valid past events" do
    assert_includes @fan1.past_events, events(:event1)
    assert_not_includes @fan1.past_events, events(:event2)
  end

  test "should valid next events" do
    assert_includes @fan1.next_events, events(:event2)
    assert_not_includes @fan1.next_events, events(:event1)
  end


end
