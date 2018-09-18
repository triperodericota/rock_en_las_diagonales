require 'test_helper'

class FansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fan = fans(:fan1)
  end

  test "should get index" do
    get fans_url
    assert_response :success
  end

  test "should get new" do
    get new_fan_url
    assert_response :success
  end

  test "should create fan" do
    assert_difference('fans.count') do
      post fans_url, params: { fan: {  } }
    end

    assert_redirected_to fan_url(Fan.last)
  end

  test "should show fan" do
    get fan_url(@fan)
    assert_response :success
  end

  test "should get edit" do
    get edit_fan_url(@fan)
    assert_response :success
  end

  test "should update fan" do
    patch fan_url(@fan), params: { fan: {  } }
    assert_redirected_to fan_url(@fan)
  end

  test "should destroy fan" do
    assert_difference('fans.count', -1) do
      delete fan_url(@fan)
    end

    assert_redirected_to fans_url
  end
end
