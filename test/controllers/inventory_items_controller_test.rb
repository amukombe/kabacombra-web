require "test_helper"

class InventoryItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inventory_item = inventory_items(:one)
  end

  test "should get index" do
    get inventory_items_url
    assert_response :success
  end

  test "should get new" do
    get new_inventory_item_url
    assert_response :success
  end

  test "should create inventory_item" do
    assert_difference("InventoryItem.count") do
      post inventory_items_url, params: { inventory_item: { delivery_time: @inventory_item.delivery_time, expiry_date: @inventory_item.expiry_date, inventory_id: @inventory_item.inventory_id, is_active: @inventory_item.is_active, is_closed: @inventory_item.is_closed, is_deleted: @inventory_item.is_deleted, manufacture_date: @inventory_item.manufacture_date, nile_product_id: @inventory_item.nile_product_id, purchase_price: @inventory_item.purchase_price, quantity_dispatched: @inventory_item.quantity_dispatched, quantity_ordered: @inventory_item.quantity_ordered, quantity_received: @inventory_item.quantity_received, quantity_sold: @inventory_item.quantity_sold, selling_price: @inventory_item.selling_price, user_id: @inventory_item.user_id } }
    end

    assert_redirected_to inventory_item_url(InventoryItem.last)
  end

  test "should show inventory_item" do
    get inventory_item_url(@inventory_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_inventory_item_url(@inventory_item)
    assert_response :success
  end

  test "should update inventory_item" do
    patch inventory_item_url(@inventory_item), params: { inventory_item: { delivery_time: @inventory_item.delivery_time, expiry_date: @inventory_item.expiry_date, inventory_id: @inventory_item.inventory_id, is_active: @inventory_item.is_active, is_closed: @inventory_item.is_closed, is_deleted: @inventory_item.is_deleted, manufacture_date: @inventory_item.manufacture_date, nile_product_id: @inventory_item.nile_product_id, purchase_price: @inventory_item.purchase_price, quantity_dispatched: @inventory_item.quantity_dispatched, quantity_ordered: @inventory_item.quantity_ordered, quantity_received: @inventory_item.quantity_received, quantity_sold: @inventory_item.quantity_sold, selling_price: @inventory_item.selling_price, user_id: @inventory_item.user_id } }
    assert_redirected_to inventory_item_url(@inventory_item)
  end

  test "should destroy inventory_item" do
    assert_difference("InventoryItem.count", -1) do
      delete inventory_item_url(@inventory_item)
    end

    assert_redirected_to inventory_items_url
  end
end
