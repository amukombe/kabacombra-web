require "application_system_test_case"

class BeerDispatchesTest < ApplicationSystemTestCase
  setup do
    @beer_dispatch = beer_dispatches(:one)
  end

  test "visiting the index" do
    visit beer_dispatches_url
    assert_selector "h1", text: "Beer dispatches"
  end

  test "should create beer dispatch" do
    visit beer_dispatches_url
    click_on "New beer dispatch"

    fill_in "Delivery plant", with: @beer_dispatch.delivery_plant
    fill_in "Dispatch no", with: @beer_dispatch.dispatch_no
    fill_in "Driver", with: @beer_dispatch.driver_id
    fill_in "Fdn number", with: @beer_dispatch.fdn_number
    fill_in "Loading time", with: @beer_dispatch.loading_time
    fill_in "Order", with: @beer_dispatch.order_id
    fill_in "Second trailer", with: @beer_dispatch.second_trailer
    fill_in "Shipping point", with: @beer_dispatch.shipping_point
    fill_in "Trailer plate", with: @beer_dispatch.trailer_plate
    fill_in "Truck numberplate", with: @beer_dispatch.truck_numberplate
    fill_in "User", with: @beer_dispatch.user_id
    click_on "Create Beer dispatch"

    assert_text "Beer dispatch was successfully created"
    click_on "Back"
  end

  test "should update Beer dispatch" do
    visit beer_dispatch_url(@beer_dispatch)
    click_on "Edit this beer dispatch", match: :first

    fill_in "Delivery plant", with: @beer_dispatch.delivery_plant
    fill_in "Dispatch no", with: @beer_dispatch.dispatch_no
    fill_in "Driver", with: @beer_dispatch.driver_id
    fill_in "Fdn number", with: @beer_dispatch.fdn_number
    fill_in "Loading time", with: @beer_dispatch.loading_time.to_s
    fill_in "Order", with: @beer_dispatch.order_id
    fill_in "Second trailer", with: @beer_dispatch.second_trailer
    fill_in "Shipping point", with: @beer_dispatch.shipping_point
    fill_in "Trailer plate", with: @beer_dispatch.trailer_plate
    fill_in "Truck numberplate", with: @beer_dispatch.truck_numberplate
    fill_in "User", with: @beer_dispatch.user_id
    click_on "Update Beer dispatch"

    assert_text "Beer dispatch was successfully updated"
    click_on "Back"
  end

  test "should destroy Beer dispatch" do
    visit beer_dispatch_url(@beer_dispatch)
    click_on "Destroy this beer dispatch", match: :first

    assert_text "Beer dispatch was successfully destroyed"
  end
end
