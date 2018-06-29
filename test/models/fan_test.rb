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


end
