require 'test_helper'

class LinesControllerTest < ActionController::TestCase
  setup do
    @line = lines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lines)
  end

  test "should create line" do
    assert_difference('Line.count') do
      post :create, line: { destination: @line.destination, name: @line.name, origin: @line.origin, stif: @line.stif }
    end

    assert_response 201
  end

  test "should show line" do
    get :show, id: @line
    assert_response :success
  end

  test "should update line" do
    put :update, id: @line, line: { destination: @line.destination, name: @line.name, origin: @line.origin, stif: @line.stif }
    assert_response 204
  end

  test "should destroy line" do
    assert_difference('Line.count', -1) do
      delete :destroy, id: @line
    end

    assert_response 204
  end
end
