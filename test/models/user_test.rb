require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user1 = users(:fan1_user)
    @user2 = users(:fan2_user)
    @user3 = users(:artist1_user)
    @user4 = users(:artist2_user)
    @user5 = User.create(email: 'newuser@mail.com', username: 'user5', encrypted_password: '12345678', profile: fans(:fan3))
  end

  teardown do
    @user5.destroy
  end

  test "should valid user's profile is a fan" do
    assert @user1.fan?
    assert_not @user3.fan?
  end

  test "should valid user's profile is an artist" do
    assert @user4.artist?
    assert_not @user2.artist?
  end

  test "should valid if user's profile change" do
    assert @user5.fan?
    @user5.profile = artists(:artist3)
    assert @user5.artist?
  end

end
