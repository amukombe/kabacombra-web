require "application_system_test_case"

class BankReconciliationsTest < ApplicationSystemTestCase
  setup do
    @bank_reconciliation = bank_reconciliations(:one)
  end

  test "visiting the index" do
    visit bank_reconciliations_url
    assert_selector "h1", text: "Bank reconciliations"
  end

  test "should create bank reconciliation" do
    visit bank_reconciliations_url
    click_on "New bank reconciliation"

    fill_in "Bank account", with: @bank_reconciliation.bank_account_id
    fill_in "Bank balance", with: @bank_reconciliation.bank_balance
    fill_in "Book balance", with: @bank_reconciliation.book_balance
    fill_in "Difference", with: @bank_reconciliation.difference
    fill_in "Reconciled at", with: @bank_reconciliation.reconciled_at
    fill_in "Reference", with: @bank_reconciliation.reference
    fill_in "Statement from", with: @bank_reconciliation.statement_from
    fill_in "Statement to", with: @bank_reconciliation.statement_to
    fill_in "Status", with: @bank_reconciliation.status
    fill_in "Territory", with: @bank_reconciliation.territory_id
    fill_in "User", with: @bank_reconciliation.user_id
    click_on "Create Bank reconciliation"

    assert_text "Bank reconciliation was successfully created"
    click_on "Back"
  end

  test "should update Bank reconciliation" do
    visit bank_reconciliation_url(@bank_reconciliation)
    click_on "Edit this bank reconciliation", match: :first

    fill_in "Bank account", with: @bank_reconciliation.bank_account_id
    fill_in "Bank balance", with: @bank_reconciliation.bank_balance
    fill_in "Book balance", with: @bank_reconciliation.book_balance
    fill_in "Difference", with: @bank_reconciliation.difference
    fill_in "Reconciled at", with: @bank_reconciliation.reconciled_at.to_s
    fill_in "Reference", with: @bank_reconciliation.reference
    fill_in "Statement from", with: @bank_reconciliation.statement_from
    fill_in "Statement to", with: @bank_reconciliation.statement_to
    fill_in "Status", with: @bank_reconciliation.status
    fill_in "Territory", with: @bank_reconciliation.territory_id
    fill_in "User", with: @bank_reconciliation.user_id
    click_on "Update Bank reconciliation"

    assert_text "Bank reconciliation was successfully updated"
    click_on "Back"
  end

  test "should destroy Bank reconciliation" do
    visit bank_reconciliation_url(@bank_reconciliation)
    click_on "Destroy this bank reconciliation", match: :first

    assert_text "Bank reconciliation was successfully destroyed"
  end
end
