require "application_system_test_case"

class ChequesTest < ApplicationSystemTestCase
  setup do
    @cheque = cheques(:one)
  end

  test "visiting the index" do
    visit cheques_url
    assert_selector "h1", text: "Cheques"
  end

  test "should create cheque" do
    visit cheques_url
    click_on "New cheque"

    fill_in "Bank transaction", with: @cheque.bank_transaction_id
    fill_in "Cheque number", with: @cheque.cheque_number
    fill_in "Cleared date", with: @cheque.cleared_date
    fill_in "Issue date", with: @cheque.issue_date
    fill_in "Payee", with: @cheque.payee
    fill_in "Status", with: @cheque.status
    fill_in "Territory", with: @cheque.territory_id
    fill_in "User", with: @cheque.user_id
    click_on "Create Cheque"

    assert_text "Cheque was successfully created"
    click_on "Back"
  end

  test "should update Cheque" do
    visit cheque_url(@cheque)
    click_on "Edit this cheque", match: :first

    fill_in "Bank transaction", with: @cheque.bank_transaction_id
    fill_in "Cheque number", with: @cheque.cheque_number
    fill_in "Cleared date", with: @cheque.cleared_date
    fill_in "Issue date", with: @cheque.issue_date
    fill_in "Payee", with: @cheque.payee
    fill_in "Status", with: @cheque.status
    fill_in "Territory", with: @cheque.territory_id
    fill_in "User", with: @cheque.user_id
    click_on "Update Cheque"

    assert_text "Cheque was successfully updated"
    click_on "Back"
  end

  test "should destroy Cheque" do
    visit cheque_url(@cheque)
    click_on "Destroy this cheque", match: :first

    assert_text "Cheque was successfully destroyed"
  end
end
