require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user1 = users(:fan1_user)
    @user2 = users(:fan2_user)
    @user3 = users(:artist1_user)
    @user4 = users(:artist2_user)
    @user5 = User.create(email: 'newuser@mail.com', username: 'user5', encrypted_password: '12345678', profile: fans(:fan2))
  end

  test "should valid user is a fan" do
    assert @user1.fan?
    assert_not @user3.fan?
  end

  test "should valid user is an artist" do
    assert @user4.artist?
    assert_not @user2.artist?
  end

end
