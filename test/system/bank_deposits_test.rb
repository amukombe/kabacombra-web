require "application_system_test_case"

class BankDepositsTest < ApplicationSystemTestCase
  setup do
    @bank_deposit = bank_deposits(:one)
  end

  test "visiting the index" do
    visit bank_deposits_url
    assert_selector "h1", text: "Bank deposits"
  end

  test "should create bank deposit" do
    visit bank_deposits_url
    click_on "New bank deposit"

    fill_in "Additional info", with: @bank_deposit.additional_info
    fill_in "Amount", with: @bank_deposit.amount
    fill_in "Bank account", with: @bank_deposit.bank_account_id
    fill_in "Deposit date", with: @bank_deposit.deposit_date
    fill_in "Deposit location", with: @bank_deposit.deposit_location
    fill_in "Deposited by", with: @bank_deposit.deposited_by
    fill_in "Source of income", with: @bank_deposit.source_of_income
    fill_in "Territory", with: @bank_deposit.territory_id
    fill_in "Transaction reference", with: @bank_deposit.transaction_reference
    fill_in "User", with: @bank_deposit.user_id
    click_on "Create Bank deposit"

    assert_text "Bank deposit was successfully created"
    click_on "Back"
  end

  test "should update Bank deposit" do
    visit bank_deposit_url(@bank_deposit)
    click_on "Edit this bank deposit", match: :first

    fill_in "Additional info", with: @bank_deposit.additional_info
    fill_in "Amount", with: @bank_deposit.amount
    fill_in "Bank account", with: @bank_deposit.bank_account_id
    fill_in "Deposit date", with: @bank_deposit.deposit_date
    fill_in "Deposit location", with: @bank_deposit.deposit_location
    fill_in "Deposited by", with: @bank_deposit.deposited_by
    fill_in "Source of income", with: @bank_deposit.source_of_income
    fill_in "Territory", with: @bank_deposit.territory_id
    fill_in "Transaction reference", with: @bank_deposit.transaction_reference
    fill_in "User", with: @bank_deposit.user_id
    click_on "Update Bank deposit"

    assert_text "Bank deposit was successfully updated"
    click_on "Back"
  end

  test "should destroy Bank deposit" do
    visit bank_deposit_url(@bank_deposit)
    click_on "Destroy this bank deposit", match: :first

    assert_text "Bank deposit was successfully destroyed"
  end
end
