require "test_helper"

class LoadingOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loading_order = loading_orders(:one)
  end

  test "should get index" do
    get loading_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_loading_order_url
    assert_response :success
  end

  test "should create loading_order" do
    assert_difference("LoadingOrder.count") do
      post loading_orders_url, params: { loading_order: { authorized_by: @loading_order.authorized_by, destination: @loading_order.destination, driver_id: @loading_order.driver_id, loading_date: @loading_order.loading_date, order_number: @loading_order.order_number, sales_man: @loading_order.sales_man, territory_id: @loading_order.territory_id, user_id: @loading_order.user_id, vehicle_numperplate: @loading_order.vehicle_numperplate, verified_by: @loading_order.verified_by } }
    end

    assert_redirected_to loading_order_url(LoadingOrder.last)
  end

  test "should show loading_order" do
    get loading_order_url(@loading_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_loading_order_url(@loading_order)
    assert_response :success
  end

  test "should update loading_order" do
    patch loading_order_url(@loading_order), params: { loading_order: { authorized_by: @loading_order.authorized_by, destination: @loading_order.destination, driver_id: @loading_order.driver_id, loading_date: @loading_order.loading_date, order_number: @loading_order.order_number, sales_man: @loading_order.sales_man, territory_id: @loading_order.territory_id, user_id: @loading_order.user_id, vehicle_numperplate: @loading_order.vehicle_numperplate, verified_by: @loading_order.verified_by } }
    assert_redirected_to loading_order_url(@loading_order)
  end

  test "should destroy loading_order" do
    assert_difference("LoadingOrder.count", -1) do
      delete loading_order_url(@loading_order)
    end

    assert_redirected_to loading_orders_url
  end
end
