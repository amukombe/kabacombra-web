require "test_helper"

class TruckTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @truck_type = truck_types(:one)
  end

  test "should get index" do
    get truck_types_url
    assert_response :success
  end

  test "should get new" do
    get new_truck_type_url
    assert_response :success
  end

  test "should create truck_type" do
    assert_difference("TruckType.count") do
      post truck_types_url, params: { truck_type: { description: @truck_type.description, name: @truck_type.name } }
    end

    assert_redirected_to truck_type_url(TruckType.last)
  end

  test "should show truck_type" do
    get truck_type_url(@truck_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_truck_type_url(@truck_type)
    assert_response :success
  end

  test "should update truck_type" do
    patch truck_type_url(@truck_type), params: { truck_type: { description: @truck_type.description, name: @truck_type.name } }
    assert_redirected_to truck_type_url(@truck_type)
  end

  test "should destroy truck_type" do
    assert_difference("TruckType.count", -1) do
      delete truck_type_url(@truck_type)
    end

    assert_redirected_to truck_types_url
  end
end
