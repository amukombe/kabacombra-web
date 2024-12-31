require "test_helper"

class BankWithdrawsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bank_withdraw = bank_withdraws(:one)
  end

  test "should get index" do
    get bank_withdraws_url
    assert_response :success
  end

  test "should get new" do
    get new_bank_withdraw_url
    assert_response :success
  end

  test "should create bank_withdraw" do
    assert_difference("BankWithdraw.count") do
      post bank_withdraws_url, params: { bank_withdraw: { additional_info: @bank_withdraw.additional_info, amount: @bank_withdraw.amount, bank_account_id: @bank_withdraw.bank_account_id, reason: @bank_withdraw.reason, territory_id: @bank_withdraw.territory_id, transaction_reference: @bank_withdraw.transaction_reference, user_id: @bank_withdraw.user_id, withdraw_date: @bank_withdraw.withdraw_date, withdraw_location: @bank_withdraw.withdraw_location, withdrawn_by: @bank_withdraw.withdrawn_by } }
    end

    assert_redirected_to bank_withdraw_url(BankWithdraw.last)
  end

  test "should show bank_withdraw" do
    get bank_withdraw_url(@bank_withdraw)
    assert_response :success
  end

  test "should get edit" do
    get edit_bank_withdraw_url(@bank_withdraw)
    assert_response :success
  end

  test "should update bank_withdraw" do
    patch bank_withdraw_url(@bank_withdraw), params: { bank_withdraw: { additional_info: @bank_withdraw.additional_info, amount: @bank_withdraw.amount, bank_account_id: @bank_withdraw.bank_account_id, reason: @bank_withdraw.reason, territory_id: @bank_withdraw.territory_id, transaction_reference: @bank_withdraw.transaction_reference, user_id: @bank_withdraw.user_id, withdraw_date: @bank_withdraw.withdraw_date, withdraw_location: @bank_withdraw.withdraw_location, withdrawn_by: @bank_withdraw.withdrawn_by } }
    assert_redirected_to bank_withdraw_url(@bank_withdraw)
  end

  test "should destroy bank_withdraw" do
    assert_difference("BankWithdraw.count", -1) do
      delete bank_withdraw_url(@bank_withdraw)
    end

    assert_redirected_to bank_withdraws_url
  end
end
