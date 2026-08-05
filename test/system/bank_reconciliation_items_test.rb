require "application_system_test_case"

class BankReconciliationItemsTest < ApplicationSystemTestCase
  setup do
    @bank_reconciliation_item = bank_reconciliation_items(:one)
  end

  test "visiting the index" do
    visit bank_reconciliation_items_url
    assert_selector "h1", text: "Bank reconciliation items"
  end

  test "should create bank reconciliation item" do
    visit bank_reconciliation_items_url
    click_on "New bank reconciliation item"

    fill_in "Bank amount", with: @bank_reconciliation_item.bank_amount
    fill_in "Bank date", with: @bank_reconciliation_item.bank_date
    fill_in "Bank reconciliation", with: @bank_reconciliation_item.bank_reconciliation_id
    fill_in "Bank reference", with: @bank_reconciliation_item.bank_reference
    fill_in "Bank transaction", with: @bank_reconciliation_item.bank_transaction_id
    check "Cleared" if @bank_reconciliation_item.cleared
    fill_in "Description", with: @bank_reconciliation_item.description
    check "Matched" if @bank_reconciliation_item.matched
    fill_in "Notes", with: @bank_reconciliation_item.notes
    click_on "Create Bank reconciliation item"

    assert_text "Bank reconciliation item was successfully created"
    click_on "Back"
  end

  test "should update Bank reconciliation item" do
    visit bank_reconciliation_item_url(@bank_reconciliation_item)
    click_on "Edit this bank reconciliation item", match: :first

    fill_in "Bank amount", with: @bank_reconciliation_item.bank_amount
    fill_in "Bank date", with: @bank_reconciliation_item.bank_date
    fill_in "Bank reconciliation", with: @bank_reconciliation_item.bank_reconciliation_id
    fill_in "Bank reference", with: @bank_reconciliation_item.bank_reference
    fill_in "Bank transaction", with: @bank_reconciliation_item.bank_transaction_id
    check "Cleared" if @bank_reconciliation_item.cleared
    fill_in "Description", with: @bank_reconciliation_item.description
    check "Matched" if @bank_reconciliation_item.matched
    fill_in "Notes", with: @bank_reconciliation_item.notes
    click_on "Update Bank reconciliation item"

    assert_text "Bank reconciliation item was successfully updated"
    click_on "Back"
  end

  test "should destroy Bank reconciliation item" do
    visit bank_reconciliation_item_url(@bank_reconciliation_item)
    click_on "Destroy this bank reconciliation item", match: :first

    assert_text "Bank reconciliation item was successfully destroyed"
  end
end
