require 'test_helper'

class UserRegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_registrations_create_url
    assert_response :success
  end

end
