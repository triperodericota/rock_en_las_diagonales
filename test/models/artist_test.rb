require 'test_helper'

class ArtistTest < ActiveSupport::TestCase

  setup do
    @artist1 = artists(:artist1)
    @artist2 = artists(:artist2)
    @artist3 = Artist.new(name: 'Riff')
    @artist1.fans << fans(:fan1) <<  fans(:fan2)
  end

  teardown do
    @artist3.destroy
  end

  test "should valid to_param" do
    assert_equal "La blusera", @artist1.to_param
    assert_equal "Patricio Rey", @artist2.to_param
    assert_equal "Riff", @artist3.to_param
  end

  test "should valid amount of followers" do
    assert_equal 2, @artist1.amount_of_followers
    assert_equal 0, @artist2.amount_of_followers
  end

  test "should valid amount of followers when fan's removed" do
    @artist1.fans.last.delete
    assert_equal 1, @artist1.amount_of_followers
  end

  test "should valid amount of followers when artist's added" do
    @artist2.fans << fans(:fan1)
    assert_equal 1, @artist2.amount_of_followers
  end

  test "should valid is followed for a fan" do
    @artist1.fans.last.delete
    assert @artist1.is_followed_for? fans(:fan2)
    assert_not @artist1.is_followed_for? fans(:fan1)
    assert_not @artist3.is_followed_for? fans(:fan3)
  end

  test "should valid is followed for a fan when is removed" do
    @artist1.fans.last.delete
    assert_not @artist2.is_followed_for? fans(:fan1)
  end



end
