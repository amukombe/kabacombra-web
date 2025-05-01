require "application_system_test_case"

class StockTransfersTest < ApplicationSystemTestCase
  setup do
    @stock_transfer = stock_transfers(:one)
  end

  test "visiting the index" do
    visit stock_transfers_url
    assert_selector "h1", text: "Stock transfers"
  end

  test "should create stock transfer" do
    visit stock_transfers_url
    click_on "New stock transfer"

    fill_in "Description", with: @stock_transfer.description
    fill_in "Destination", with: @stock_transfer.destination_id
    fill_in "Destination type", with: @stock_transfer.destination_type
    fill_in "Source", with: @stock_transfer.source_id
    fill_in "Source type", with: @stock_transfer.source_type
    fill_in "Status", with: @stock_transfer.status
    fill_in "Transfer date", with: @stock_transfer.transfer_date
    fill_in "Transfer type", with: @stock_transfer.transfer_type
    click_on "Create Stock transfer"

    assert_text "Stock transfer was successfully created"
    click_on "Back"
  end

  test "should update Stock transfer" do
    visit stock_transfer_url(@stock_transfer)
    click_on "Edit this stock transfer", match: :first

    fill_in "Description", with: @stock_transfer.description
    fill_in "Destination", with: @stock_transfer.destination_id
    fill_in "Destination type", with: @stock_transfer.destination_type
    fill_in "Source", with: @stock_transfer.source_id
    fill_in "Source type", with: @stock_transfer.source_type
    fill_in "Status", with: @stock_transfer.status
    fill_in "Transfer date", with: @stock_transfer.transfer_date
    fill_in "Transfer type", with: @stock_transfer.transfer_type
    click_on "Update Stock transfer"

    assert_text "Stock transfer was successfully updated"
    click_on "Back"
  end

  test "should destroy Stock transfer" do
    visit stock_transfer_url(@stock_transfer)
    click_on "Destroy this stock transfer", match: :first

    assert_text "Stock transfer was successfully destroyed"
  end
end
