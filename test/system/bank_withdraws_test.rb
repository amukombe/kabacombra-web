require "application_system_test_case"

class BankWithdrawsTest < ApplicationSystemTestCase
  setup do
    @bank_withdraw = bank_withdraws(:one)
  end

  test "visiting the index" do
    visit bank_withdraws_url
    assert_selector "h1", text: "Bank withdraws"
  end

  test "should create bank withdraw" do
    visit bank_withdraws_url
    click_on "New bank withdraw"

    fill_in "Additional info", with: @bank_withdraw.additional_info
    fill_in "Amount", with: @bank_withdraw.amount
    fill_in "Bank account", with: @bank_withdraw.bank_account_id
    fill_in "Reason", with: @bank_withdraw.reason
    fill_in "Territory", with: @bank_withdraw.territory_id
    fill_in "Transaction reference", with: @bank_withdraw.transaction_reference
    fill_in "User", with: @bank_withdraw.user_id
    fill_in "Withdraw date", with: @bank_withdraw.withdraw_date
    fill_in "Withdraw location", with: @bank_withdraw.withdraw_location
    fill_in "Withdrawn by", with: @bank_withdraw.withdrawn_by
    click_on "Create Bank withdraw"

    assert_text "Bank withdraw was successfully created"
    click_on "Back"
  end

  test "should update Bank withdraw" do
    visit bank_withdraw_url(@bank_withdraw)
    click_on "Edit this bank withdraw", match: :first

    fill_in "Additional info", with: @bank_withdraw.additional_info
    fill_in "Amount", with: @bank_withdraw.amount
    fill_in "Bank account", with: @bank_withdraw.bank_account_id
    fill_in "Reason", with: @bank_withdraw.reason
    fill_in "Territory", with: @bank_withdraw.territory_id
    fill_in "Transaction reference", with: @bank_withdraw.transaction_reference
    fill_in "User", with: @bank_withdraw.user_id
    fill_in "Withdraw date", with: @bank_withdraw.withdraw_date
    fill_in "Withdraw location", with: @bank_withdraw.withdraw_location
    fill_in "Withdrawn by", with: @bank_withdraw.withdrawn_by
    click_on "Update Bank withdraw"

    assert_text "Bank withdraw was successfully updated"
    click_on "Back"
  end

  test "should destroy Bank withdraw" do
    visit bank_withdraw_url(@bank_withdraw)
    click_on "Destroy this bank withdraw", match: :first

    assert_text "Bank withdraw was successfully destroyed"
  end
end
