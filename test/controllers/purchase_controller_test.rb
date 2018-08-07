require 'test_helper'

class PurchaseControllerTest < ActionDispatch::IntegrationTest
  test "should get buy" do
    get purchase_buy_url
    assert_response :success
  end

end
