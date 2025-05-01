require "test_helper"

class StockTransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock_transfer = stock_transfers(:one)
  end

  test "should get index" do
    get stock_transfers_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_transfer_url
    assert_response :success
  end

  test "should create stock_transfer" do
    assert_difference("StockTransfer.count") do
      post stock_transfers_url, params: { stock_transfer: { description: @stock_transfer.description, destination_id: @stock_transfer.destination_id, destination_type: @stock_transfer.destination_type, source_id: @stock_transfer.source_id, source_type: @stock_transfer.source_type, status: @stock_transfer.status, transfer_date: @stock_transfer.transfer_date, transfer_type: @stock_transfer.transfer_type } }
    end

    assert_redirected_to stock_transfer_url(StockTransfer.last)
  end

  test "should show stock_transfer" do
    get stock_transfer_url(@stock_transfer)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_transfer_url(@stock_transfer)
    assert_response :success
  end

  test "should update stock_transfer" do
    patch stock_transfer_url(@stock_transfer), params: { stock_transfer: { description: @stock_transfer.description, destination_id: @stock_transfer.destination_id, destination_type: @stock_transfer.destination_type, source_id: @stock_transfer.source_id, source_type: @stock_transfer.source_type, status: @stock_transfer.status, transfer_date: @stock_transfer.transfer_date, transfer_type: @stock_transfer.transfer_type } }
    assert_redirected_to stock_transfer_url(@stock_transfer)
  end

  test "should destroy stock_transfer" do
    assert_difference("StockTransfer.count", -1) do
      delete stock_transfer_url(@stock_transfer)
    end

    assert_redirected_to stock_transfers_url
  end
end
