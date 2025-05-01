require "application_system_test_case"

class StockTransferItemsTest < ApplicationSystemTestCase
  setup do
    @stock_transfer_item = stock_transfer_items(:one)
  end

  test "visiting the index" do
    visit stock_transfer_items_url
    assert_selector "h1", text: "Stock transfer items"
  end

  test "should create stock transfer item" do
    visit stock_transfer_items_url
    click_on "New stock transfer item"

    fill_in "Nile product", with: @stock_transfer_item.nile_product_id
    fill_in "Stock transfer", with: @stock_transfer_item.stock_transfer_id
    fill_in "Transfer quantity", with: @stock_transfer_item.transfer_quantity
    click_on "Create Stock transfer item"

    assert_text "Stock transfer item was successfully created"
    click_on "Back"
  end

  test "should update Stock transfer item" do
    visit stock_transfer_item_url(@stock_transfer_item)
    click_on "Edit this stock transfer item", match: :first

    fill_in "Nile product", with: @stock_transfer_item.nile_product_id
    fill_in "Stock transfer", with: @stock_transfer_item.stock_transfer_id
    fill_in "Transfer quantity", with: @stock_transfer_item.transfer_quantity
    click_on "Update Stock transfer item"

    assert_text "Stock transfer item was successfully updated"
    click_on "Back"
  end

  test "should destroy Stock transfer item" do
    visit stock_transfer_item_url(@stock_transfer_item)
    click_on "Destroy this stock transfer item", match: :first

    assert_text "Stock transfer item was successfully destroyed"
  end
end
