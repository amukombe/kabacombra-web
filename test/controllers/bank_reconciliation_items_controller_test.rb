require "test_helper"

class BankReconciliationItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bank_reconciliation_item = bank_reconciliation_items(:one)
  end

  test "should get index" do
    get bank_reconciliation_items_url
    assert_response :success
  end

  test "should get new" do
    get new_bank_reconciliation_item_url
    assert_response :success
  end

  test "should create bank_reconciliation_item" do
    assert_difference("BankReconciliationItem.count") do
      post bank_reconciliation_items_url, params: { bank_reconciliation_item: { bank_amount: @bank_reconciliation_item.bank_amount, bank_date: @bank_reconciliation_item.bank_date, bank_reconciliation_id: @bank_reconciliation_item.bank_reconciliation_id, bank_reference: @bank_reconciliation_item.bank_reference, bank_transaction_id: @bank_reconciliation_item.bank_transaction_id, cleared: @bank_reconciliation_item.cleared, description: @bank_reconciliation_item.description, matched: @bank_reconciliation_item.matched, notes: @bank_reconciliation_item.notes } }
    end

    assert_redirected_to bank_reconciliation_item_url(BankReconciliationItem.last)
  end

  test "should show bank_reconciliation_item" do
    get bank_reconciliation_item_url(@bank_reconciliation_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_bank_reconciliation_item_url(@bank_reconciliation_item)
    assert_response :success
  end

  test "should update bank_reconciliation_item" do
    patch bank_reconciliation_item_url(@bank_reconciliation_item), params: { bank_reconciliation_item: { bank_amount: @bank_reconciliation_item.bank_amount, bank_date: @bank_reconciliation_item.bank_date, bank_reconciliation_id: @bank_reconciliation_item.bank_reconciliation_id, bank_reference: @bank_reconciliation_item.bank_reference, bank_transaction_id: @bank_reconciliation_item.bank_transaction_id, cleared: @bank_reconciliation_item.cleared, description: @bank_reconciliation_item.description, matched: @bank_reconciliation_item.matched, notes: @bank_reconciliation_item.notes } }
    assert_redirected_to bank_reconciliation_item_url(@bank_reconciliation_item)
  end

  test "should destroy bank_reconciliation_item" do
    assert_difference("BankReconciliationItem.count", -1) do
      delete bank_reconciliation_item_url(@bank_reconciliation_item)
    end

    assert_redirected_to bank_reconciliation_items_url
  end
end
