require "test_helper"

class OrderDriversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order_driver = order_drivers(:one)
  end

  test "should get index" do
    get order_drivers_url
    assert_response :success
  end

  test "should get new" do
    get new_order_driver_url
    assert_response :success
  end

  test "should create order_driver" do
    assert_difference("OrderDriver.count") do
      post order_drivers_url, params: { order_driver: { driver_id: @order_driver.driver_id, order_id: @order_driver.order_id } }
    end

    assert_redirected_to order_driver_url(OrderDriver.last)
  end

  test "should show order_driver" do
    get order_driver_url(@order_driver)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_driver_url(@order_driver)
    assert_response :success
  end

  test "should update order_driver" do
    patch order_driver_url(@order_driver), params: { order_driver: { driver_id: @order_driver.driver_id, order_id: @order_driver.order_id } }
    assert_redirected_to order_driver_url(@order_driver)
  end

  test "should destroy order_driver" do
    assert_difference("OrderDriver.count", -1) do
      delete order_driver_url(@order_driver)
    end

    assert_redirected_to order_drivers_url
  end
end
