require "test_helper"

class BeerReturnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @beer_return = beer_returns(:one)
  end

  test "should get index" do
    get beer_returns_url
    assert_response :success
  end

  test "should get new" do
    get new_beer_return_url
    assert_response :success
  end

  test "should create beer_return" do
    assert_difference("BeerReturn.count") do
      post beer_returns_url, params: { beer_return: { loading_order_id: @beer_return.loading_order_id, return_date: @beer_return.return_date } }
    end

    assert_redirected_to beer_return_url(BeerReturn.last)
  end

  test "should show beer_return" do
    get beer_return_url(@beer_return)
    assert_response :success
  end

  test "should get edit" do
    get edit_beer_return_url(@beer_return)
    assert_response :success
  end

  test "should update beer_return" do
    patch beer_return_url(@beer_return), params: { beer_return: { loading_order_id: @beer_return.loading_order_id, return_date: @beer_return.return_date } }
    assert_redirected_to beer_return_url(@beer_return)
  end

  test "should destroy beer_return" do
    assert_difference("BeerReturn.count", -1) do
      delete beer_return_url(@beer_return)
    end

    assert_redirected_to beer_returns_url
  end
end
