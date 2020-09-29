require 'test_helper'

class EventTest < ActiveSupport::TestCase

  setup do
    @event1 = events(:event1)
    @event2 = events(:event2)
    @event3 = events(:event3)
  end

  test "should valid start date is earlier than end date" do
    new_event = Event.new(title: 'new event', start_date: DateTime.tomorrow, end_date: DateTime.current, artist: artists(:artist3))
    assert_not new_event.valid?
    assert_includes new_event.errors, :end_date
  end

  test "should valid if it is finished" do
    # not tested the case which end_date = DateTime.current because when compare end_date and DateTime.current
    # in #finished? fails due to DateTime.current is greater than end_date in the initialize moment
    assert @event1.finished?
    assert_not @event2.finished?
  end

  test "should valid if it is currently" do
    currently_event = Event.new(title: 'new event', start_date: DateTime.current - 1.hours, end_date: DateTime.current + 1.hours, artist: artists(:artist3))
    assert currently_event.currently?
    currently_event.start_date = DateTime.current
    assert currently_event.currently?
  end

  test "should valid audience amount" do
    assert_equal @event1.audience_amount, 2
    assert_equal @event3.audience_amount, 0
  end

  test "should valid audience amount when add new assistant" do
    new_assistant = fans(:fan3)
    new_assistant.events << @event1
    assert_equal @event1.audience_amount, 3
  end

  test "should valid audience amount when remove assistant" do
    assistant = fans(:fan3)
    assistant.events.delete(@event1)
    assert_equal @event1.audience_amount, 2
  end

  test "should valid is favourite for a fan" do
    assert @event1.is_favourite_for? fans(:fan1)
    assert_not @event2.is_favourite_for? fans(:fan2)
  end

  #it depends for the moment that the test is executed
  test "should valid how much time is left to start" do
    assert_equal @event1.how_much_time_is_left_to_start, 'Evento finalizado'
    new_event = Event.new(title: 'new event', start_date: (DateTime.tomorrow + 20.hours), end_date: (DateTime.tomorrow + 23.hours + 30.minutes), artist: artists(:artist3))
    hmt = ActiveSupport::Duration.build(new_event.start_date - DateTime.current)
    assert_equal new_event.how_much_time_is_left_to_start, "Faltan 1 día, #{hmt.parts[:hours]} horas y #{hmt.parts[:minutes]} minutos para el comienzo del evento"
  end



end
