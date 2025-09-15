require "test_helper"

class BankTransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bank_transfer = bank_transfers(:one)
  end

  test "should get index" do
    get bank_transfers_url
    assert_response :success
  end

  test "should get new" do
    get new_bank_transfer_url
    assert_response :success
  end

  test "should create bank_transfer" do
    assert_difference("BankTransfer.count") do
      post bank_transfers_url, params: { bank_transfer: { amount: @bank_transfer.amount, from_account_id: @bank_transfer.from_account_id, reason: @bank_transfer.reason, territory_id: @bank_transfer.territory_id, to_account_id: @bank_transfer.to_account_id, transfer_date: @bank_transfer.transfer_date, transfer_ref: @bank_transfer.transfer_ref, user_id: @bank_transfer.user_id } }
    end

    assert_redirected_to bank_transfer_url(BankTransfer.last)
  end

  test "should show bank_transfer" do
    get bank_transfer_url(@bank_transfer)
    assert_response :success
  end

  test "should get edit" do
    get edit_bank_transfer_url(@bank_transfer)
    assert_response :success
  end

  test "should update bank_transfer" do
    patch bank_transfer_url(@bank_transfer), params: { bank_transfer: { amount: @bank_transfer.amount, from_account_id: @bank_transfer.from_account_id, reason: @bank_transfer.reason, territory_id: @bank_transfer.territory_id, to_account_id: @bank_transfer.to_account_id, transfer_date: @bank_transfer.transfer_date, transfer_ref: @bank_transfer.transfer_ref, user_id: @bank_transfer.user_id } }
    assert_redirected_to bank_transfer_url(@bank_transfer)
  end

  test "should destroy bank_transfer" do
    assert_difference("BankTransfer.count", -1) do
      delete bank_transfer_url(@bank_transfer)
    end

    assert_redirected_to bank_transfers_url
  end
end
