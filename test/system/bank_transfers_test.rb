require "application_system_test_case"

class BankTransfersTest < ApplicationSystemTestCase
  setup do
    @bank_transfer = bank_transfers(:one)
  end

  test "visiting the index" do
    visit bank_transfers_url
    assert_selector "h1", text: "Bank transfers"
  end

  test "should create bank transfer" do
    visit bank_transfers_url
    click_on "New bank transfer"

    fill_in "Amount", with: @bank_transfer.amount
    fill_in "From account", with: @bank_transfer.from_account_id
    fill_in "Reason", with: @bank_transfer.reason
    fill_in "Territory", with: @bank_transfer.territory_id
    fill_in "To account", with: @bank_transfer.to_account_id
    fill_in "Transfer date", with: @bank_transfer.transfer_date
    fill_in "Transfer ref", with: @bank_transfer.transfer_ref
    fill_in "User", with: @bank_transfer.user_id
    click_on "Create Bank transfer"

    assert_text "Bank transfer was successfully created"
    click_on "Back"
  end

  test "should update Bank transfer" do
    visit bank_transfer_url(@bank_transfer)
    click_on "Edit this bank transfer", match: :first

    fill_in "Amount", with: @bank_transfer.amount
    fill_in "From account", with: @bank_transfer.from_account_id
    fill_in "Reason", with: @bank_transfer.reason
    fill_in "Territory", with: @bank_transfer.territory_id
    fill_in "To account", with: @bank_transfer.to_account_id
    fill_in "Transfer date", with: @bank_transfer.transfer_date.to_s
    fill_in "Transfer ref", with: @bank_transfer.transfer_ref
    fill_in "User", with: @bank_transfer.user_id
    click_on "Update Bank transfer"

    assert_text "Bank transfer was successfully updated"
    click_on "Back"
  end

  test "should destroy Bank transfer" do
    visit bank_transfer_url(@bank_transfer)
    click_on "Destroy this bank transfer", match: :first

    assert_text "Bank transfer was successfully destroyed"
  end
end
