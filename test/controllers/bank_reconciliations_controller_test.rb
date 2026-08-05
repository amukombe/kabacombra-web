require "test_helper"

class BankReconciliationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bank_reconciliation = bank_reconciliations(:one)
  end

  test "should get index" do
    get bank_reconciliations_url
    assert_response :success
  end

  test "should get new" do
    get new_bank_reconciliation_url
    assert_response :success
  end

  test "should create bank_reconciliation" do
    assert_difference("BankReconciliation.count") do
      post bank_reconciliations_url, params: { bank_reconciliation: { bank_account_id: @bank_reconciliation.bank_account_id, bank_balance: @bank_reconciliation.bank_balance, book_balance: @bank_reconciliation.book_balance, difference: @bank_reconciliation.difference, reconciled_at: @bank_reconciliation.reconciled_at, reference: @bank_reconciliation.reference, statement_from: @bank_reconciliation.statement_from, statement_to: @bank_reconciliation.statement_to, status: @bank_reconciliation.status, territory_id: @bank_reconciliation.territory_id, user_id: @bank_reconciliation.user_id } }
    end

    assert_redirected_to bank_reconciliation_url(BankReconciliation.last)
  end

  test "should show bank_reconciliation" do
    get bank_reconciliation_url(@bank_reconciliation)
    assert_response :success
  end

  test "should get edit" do
    get edit_bank_reconciliation_url(@bank_reconciliation)
    assert_response :success
  end

  test "should update bank_reconciliation" do
    patch bank_reconciliation_url(@bank_reconciliation), params: { bank_reconciliation: { bank_account_id: @bank_reconciliation.bank_account_id, bank_balance: @bank_reconciliation.bank_balance, book_balance: @bank_reconciliation.book_balance, difference: @bank_reconciliation.difference, reconciled_at: @bank_reconciliation.reconciled_at, reference: @bank_reconciliation.reference, statement_from: @bank_reconciliation.statement_from, statement_to: @bank_reconciliation.statement_to, status: @bank_reconciliation.status, territory_id: @bank_reconciliation.territory_id, user_id: @bank_reconciliation.user_id } }
    assert_redirected_to bank_reconciliation_url(@bank_reconciliation)
  end

  test "should destroy bank_reconciliation" do
    assert_difference("BankReconciliation.count", -1) do
      delete bank_reconciliation_url(@bank_reconciliation)
    end

    assert_redirected_to bank_reconciliations_url
  end
end
