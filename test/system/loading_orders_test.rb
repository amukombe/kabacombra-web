require "application_system_test_case"

class LoadingOrdersTest < ApplicationSystemTestCase
  setup do
    @loading_order = loading_orders(:one)
  end

  test "visiting the index" do
    visit loading_orders_url
    assert_selector "h1", text: "Loading orders"
  end

  test "should create loading order" do
    visit loading_orders_url
    click_on "New loading order"

    fill_in "Authorized by", with: @loading_order.authorized_by
    fill_in "Destination", with: @loading_order.destination
    fill_in "Driver", with: @loading_order.driver_id
    fill_in "Loading date", with: @loading_order.loading_date
    fill_in "Order number", with: @loading_order.order_number
    fill_in "Sales man", with: @loading_order.sales_man
    fill_in "Territory", with: @loading_order.territory_id
    fill_in "User", with: @loading_order.user_id
    fill_in "Vehicle numperplate", with: @loading_order.vehicle_numperplate
    fill_in "Verified by", with: @loading_order.verified_by
    click_on "Create Loading order"

    assert_text "Loading order was successfully created"
    click_on "Back"
  end

  test "should update Loading order" do
    visit loading_order_url(@loading_order)
    click_on "Edit this loading order", match: :first

    fill_in "Authorized by", with: @loading_order.authorized_by
    fill_in "Destination", with: @loading_order.destination
    fill_in "Driver", with: @loading_order.driver_id
    fill_in "Loading date", with: @loading_order.loading_date.to_s
    fill_in "Order number", with: @loading_order.order_number
    fill_in "Sales man", with: @loading_order.sales_man
    fill_in "Territory", with: @loading_order.territory_id
    fill_in "User", with: @loading_order.user_id
    fill_in "Vehicle numperplate", with: @loading_order.vehicle_numperplate
    fill_in "Verified by", with: @loading_order.verified_by
    click_on "Update Loading order"

    assert_text "Loading order was successfully updated"
    click_on "Back"
  end

  test "should destroy Loading order" do
    visit loading_order_url(@loading_order)
    click_on "Destroy this loading order", match: :first

    assert_text "Loading order was successfully destroyed"
  end
end
