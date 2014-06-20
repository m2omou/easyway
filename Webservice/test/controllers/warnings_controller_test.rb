require 'test_helper'

class WarningsControllerTest < ActionController::TestCase
  setup do
    @warning = warnings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:warnings)
  end

  test "should create warning" do
    assert_difference('Warning.count') do
      post :create, warning: { description: @warning.description, latitude: @warning.latitude, longitude: @warning.longitude, picture: @warning.picture }
    end

    assert_response 201
  end

  test "should show warning" do
    get :show, id: @warning
    assert_response :success
  end

  test "should update warning" do
    put :update, id: @warning, warning: { description: @warning.description, latitude: @warning.latitude, longitude: @warning.longitude, picture: @warning.picture }
    assert_response 204
  end

  test "should destroy warning" do
    assert_difference('Warning.count', -1) do
      delete :destroy, id: @warning
    end

    assert_response 204
  end
end
