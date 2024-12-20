require "application_system_test_case"

class SaleItemsTest < ApplicationSystemTestCase
  setup do
    @sale_item = sale_items(:one)
  end

  test "visiting the index" do
    visit sale_items_url
    assert_selector "h1", text: "Sale items"
  end

  test "should create sale item" do
    visit sale_items_url
    click_on "New sale item"

    fill_in "Amount", with: @sale_item.amount
    fill_in "Loading order item", with: @sale_item.loading_order_item_id
    fill_in "Quantity sold", with: @sale_item.quantity_sold
    fill_in "Total", with: @sale_item.total
    click_on "Create Sale item"

    assert_text "Sale item was successfully created"
    click_on "Back"
  end

  test "should update Sale item" do
    visit sale_item_url(@sale_item)
    click_on "Edit this sale item", match: :first

    fill_in "Amount", with: @sale_item.amount
    fill_in "Loading order item", with: @sale_item.loading_order_item_id
    fill_in "Quantity sold", with: @sale_item.quantity_sold
    fill_in "Total", with: @sale_item.total
    click_on "Update Sale item"

    assert_text "Sale item was successfully updated"
    click_on "Back"
  end

  test "should destroy Sale item" do
    visit sale_item_url(@sale_item)
    click_on "Destroy this sale item", match: :first

    assert_text "Sale item was successfully destroyed"
  end
end
