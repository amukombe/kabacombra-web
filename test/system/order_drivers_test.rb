require "application_system_test_case"

class OrderDriversTest < ApplicationSystemTestCase
  setup do
    @order_driver = order_drivers(:one)
  end

  test "visiting the index" do
    visit order_drivers_url
    assert_selector "h1", text: "Order drivers"
  end

  test "should create order driver" do
    visit order_drivers_url
    click_on "New order driver"

    fill_in "Driver", with: @order_driver.driver_id
    fill_in "Order", with: @order_driver.order_id
    click_on "Create Order driver"

    assert_text "Order driver was successfully created"
    click_on "Back"
  end

  test "should update Order driver" do
    visit order_driver_url(@order_driver)
    click_on "Edit this order driver", match: :first

    fill_in "Driver", with: @order_driver.driver_id
    fill_in "Order", with: @order_driver.order_id
    click_on "Update Order driver"

    assert_text "Order driver was successfully updated"
    click_on "Back"
  end

  test "should destroy Order driver" do
    visit order_driver_url(@order_driver)
    click_on "Destroy this order driver", match: :first

    assert_text "Order driver was successfully destroyed"
  end
end
