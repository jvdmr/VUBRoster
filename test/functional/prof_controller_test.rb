require 'test_helper'

class ProfControllerTest < ActionController::TestCase
  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

end
