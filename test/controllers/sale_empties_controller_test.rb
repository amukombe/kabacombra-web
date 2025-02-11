require "test_helper"

class SaleEmptiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sale_empty = sale_empties(:one)
  end

  test "should get index" do
    get sale_empties_url
    assert_response :success
  end

  test "should get new" do
    get new_sale_empty_url
    assert_response :success
  end

  test "should create sale_empty" do
    assert_difference("SaleEmpty.count") do
      post sale_empties_url, params: { sale_empty: { empty_type_id: @sale_empty.empty_type_id, expected: @sale_empty.expected, received: @sale_empty.received, sale_id: @sale_empty.sale_id, variance: @sale_empty.variance } }
    end

    assert_redirected_to sale_empty_url(SaleEmpty.last)
  end

  test "should show sale_empty" do
    get sale_empty_url(@sale_empty)
    assert_response :success
  end

  test "should get edit" do
    get edit_sale_empty_url(@sale_empty)
    assert_response :success
  end

  test "should update sale_empty" do
    patch sale_empty_url(@sale_empty), params: { sale_empty: { empty_type_id: @sale_empty.empty_type_id, expected: @sale_empty.expected, received: @sale_empty.received, sale_id: @sale_empty.sale_id, variance: @sale_empty.variance } }
    assert_redirected_to sale_empty_url(@sale_empty)
  end

  test "should destroy sale_empty" do
    assert_difference("SaleEmpty.count", -1) do
      delete sale_empty_url(@sale_empty)
    end

    assert_redirected_to sale_empties_url
  end
end
