require "application_system_test_case"

class InventoryItemsTest < ApplicationSystemTestCase
  setup do
    @inventory_item = inventory_items(:one)
  end

  test "visiting the index" do
    visit inventory_items_url
    assert_selector "h1", text: "Inventory items"
  end

  test "should create inventory item" do
    visit inventory_items_url
    click_on "New inventory item"

    fill_in "Delivery time", with: @inventory_item.delivery_time
    fill_in "Expiry date", with: @inventory_item.expiry_date
    fill_in "Inventory", with: @inventory_item.inventory_id
    check "Is active" if @inventory_item.is_active
    check "Is closed" if @inventory_item.is_closed
    check "Is deleted" if @inventory_item.is_deleted
    fill_in "Manufacture date", with: @inventory_item.manufacture_date
    fill_in "Nile product", with: @inventory_item.nile_product_id
    fill_in "Purchase price", with: @inventory_item.purchase_price
    fill_in "Quantity dispatched", with: @inventory_item.quantity_dispatched
    fill_in "Quantity ordered", with: @inventory_item.quantity_ordered
    fill_in "Quantity received", with: @inventory_item.quantity_received
    fill_in "Quantity sold", with: @inventory_item.quantity_sold
    fill_in "Selling price", with: @inventory_item.selling_price
    fill_in "User", with: @inventory_item.user_id
    click_on "Create Inventory item"

    assert_text "Inventory item was successfully created"
    click_on "Back"
  end

  test "should update Inventory item" do
    visit inventory_item_url(@inventory_item)
    click_on "Edit this inventory item", match: :first

    fill_in "Delivery time", with: @inventory_item.delivery_time.to_s
    fill_in "Expiry date", with: @inventory_item.expiry_date
    fill_in "Inventory", with: @inventory_item.inventory_id
    check "Is active" if @inventory_item.is_active
    check "Is closed" if @inventory_item.is_closed
    check "Is deleted" if @inventory_item.is_deleted
    fill_in "Manufacture date", with: @inventory_item.manufacture_date
    fill_in "Nile product", with: @inventory_item.nile_product_id
    fill_in "Purchase price", with: @inventory_item.purchase_price
    fill_in "Quantity dispatched", with: @inventory_item.quantity_dispatched
    fill_in "Quantity ordered", with: @inventory_item.quantity_ordered
    fill_in "Quantity received", with: @inventory_item.quantity_received
    fill_in "Quantity sold", with: @inventory_item.quantity_sold
    fill_in "Selling price", with: @inventory_item.selling_price
    fill_in "User", with: @inventory_item.user_id
    click_on "Update Inventory item"

    assert_text "Inventory item was successfully updated"
    click_on "Back"
  end

  test "should destroy Inventory item" do
    visit inventory_item_url(@inventory_item)
    click_on "Destroy this inventory item", match: :first

    assert_text "Inventory item was successfully destroyed"
  end
end
