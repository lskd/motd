require 'test_helper'

class MotdControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get page1" do
    get :page1
    assert_response :success
  end

  test "should get page2" do
    get :page2
    assert_response :success
  end

end
