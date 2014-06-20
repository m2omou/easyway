require 'test_helper'

class StopsControllerTest < ActionController::TestCase
  setup do
    @stop = stops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stops)
  end

  test "should create stop" do
    assert_difference('Stop.count') do
      post :create, stop: { accessibility: @stop.accessibility, name: @stop.name, sens: @stop.sens, stif: @stop.stif }
    end

    assert_response 201
  end

  test "should show stop" do
    get :show, id: @stop
    assert_response :success
  end

  test "should update stop" do
    put :update, id: @stop, stop: { accessibility: @stop.accessibility, name: @stop.name, sens: @stop.sens, stif: @stop.stif }
    assert_response 204
  end

  test "should destroy stop" do
    assert_difference('Stop.count', -1) do
      delete :destroy, id: @stop
    end

    assert_response 204
  end
end
