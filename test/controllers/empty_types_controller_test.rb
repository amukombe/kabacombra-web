require "test_helper"

class EmptyTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @empty_type = empty_types(:one)
  end

  test "should get index" do
    get empty_types_url
    assert_response :success
  end

  test "should get new" do
    get new_empty_type_url
    assert_response :success
  end

  test "should create empty_type" do
    assert_difference("EmptyType.count") do
      post empty_types_url, params: { empty_type: { name: @empty_type.name, price: @empty_type.price } }
    end

    assert_redirected_to empty_type_url(EmptyType.last)
  end

  test "should show empty_type" do
    get empty_type_url(@empty_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_empty_type_url(@empty_type)
    assert_response :success
  end

  test "should update empty_type" do
    patch empty_type_url(@empty_type), params: { empty_type: { name: @empty_type.name, price: @empty_type.price } }
    assert_redirected_to empty_type_url(@empty_type)
  end

  test "should destroy empty_type" do
    assert_difference("EmptyType.count", -1) do
      delete empty_type_url(@empty_type)
    end

    assert_redirected_to empty_types_url
  end
end
