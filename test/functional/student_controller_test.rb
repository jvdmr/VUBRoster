require 'test_helper'

class StudentControllerTest < ActionController::TestCase
  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get ical" do
    get :ical
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

end
