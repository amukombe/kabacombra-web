require "test_helper"

class BeerDispatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @beer_dispatch = beer_dispatches(:one)
  end

  test "should get index" do
    get beer_dispatches_url
    assert_response :success
  end

  test "should get new" do
    get new_beer_dispatch_url
    assert_response :success
  end

  test "should create beer_dispatch" do
    assert_difference("BeerDispatch.count") do
      post beer_dispatches_url, params: { beer_dispatch: { delivery_plant: @beer_dispatch.delivery_plant, dispatch_no: @beer_dispatch.dispatch_no, driver_id: @beer_dispatch.driver_id, fdn_number: @beer_dispatch.fdn_number, loading_time: @beer_dispatch.loading_time, order_id: @beer_dispatch.order_id, second_trailer: @beer_dispatch.second_trailer, shipping_point: @beer_dispatch.shipping_point, trailer_plate: @beer_dispatch.trailer_plate, truck_numberplate: @beer_dispatch.truck_numberplate, user_id: @beer_dispatch.user_id } }
    end

    assert_redirected_to beer_dispatch_url(BeerDispatch.last)
  end

  test "should show beer_dispatch" do
    get beer_dispatch_url(@beer_dispatch)
    assert_response :success
  end

  test "should get edit" do
    get edit_beer_dispatch_url(@beer_dispatch)
    assert_response :success
  end

  test "should update beer_dispatch" do
    patch beer_dispatch_url(@beer_dispatch), params: { beer_dispatch: { delivery_plant: @beer_dispatch.delivery_plant, dispatch_no: @beer_dispatch.dispatch_no, driver_id: @beer_dispatch.driver_id, fdn_number: @beer_dispatch.fdn_number, loading_time: @beer_dispatch.loading_time, order_id: @beer_dispatch.order_id, second_trailer: @beer_dispatch.second_trailer, shipping_point: @beer_dispatch.shipping_point, trailer_plate: @beer_dispatch.trailer_plate, truck_numberplate: @beer_dispatch.truck_numberplate, user_id: @beer_dispatch.user_id } }
    assert_redirected_to beer_dispatch_url(@beer_dispatch)
  end

  test "should destroy beer_dispatch" do
    assert_difference("BeerDispatch.count", -1) do
      delete beer_dispatch_url(@beer_dispatch)
    end

    assert_redirected_to beer_dispatches_url
  end
end
