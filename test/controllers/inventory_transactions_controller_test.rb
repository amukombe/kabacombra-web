require "test_helper"

class InventoryTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inventory_transaction = inventory_transactions(:one)
  end

  test "should get index" do
    get inventory_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_inventory_transaction_url
    assert_response :success
  end

  test "should create inventory_transaction" do
    assert_difference("InventoryTransaction.count") do
      post inventory_transactions_url, params: { inventory_transaction: { direction: @inventory_transaction.direction, inventory_item_id: @inventory_transaction.inventory_item_id, note: @inventory_transaction.note, transaction_date: @inventory_transaction.transaction_date, transaction_quantity: @inventory_transaction.transaction_quantity, transaction_type: @inventory_transaction.transaction_type } }
    end

    assert_redirected_to inventory_transaction_url(InventoryTransaction.last)
  end

  test "should show inventory_transaction" do
    get inventory_transaction_url(@inventory_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_inventory_transaction_url(@inventory_transaction)
    assert_response :success
  end

  test "should update inventory_transaction" do
    patch inventory_transaction_url(@inventory_transaction), params: { inventory_transaction: { direction: @inventory_transaction.direction, inventory_item_id: @inventory_transaction.inventory_item_id, note: @inventory_transaction.note, transaction_date: @inventory_transaction.transaction_date, transaction_quantity: @inventory_transaction.transaction_quantity, transaction_type: @inventory_transaction.transaction_type } }
    assert_redirected_to inventory_transaction_url(@inventory_transaction)
  end

  test "should destroy inventory_transaction" do
    assert_difference("InventoryTransaction.count", -1) do
      delete inventory_transaction_url(@inventory_transaction)
    end

    assert_redirected_to inventory_transactions_url
  end
end
