require "application_system_test_case"

class SaleEmptiesTest < ApplicationSystemTestCase
  setup do
    @sale_empty = sale_empties(:one)
  end

  test "visiting the index" do
    visit sale_empties_url
    assert_selector "h1", text: "Sale empties"
  end

  test "should create sale empty" do
    visit sale_empties_url
    click_on "New sale empty"

    fill_in "Empty type", with: @sale_empty.empty_type_id
    fill_in "Expected", with: @sale_empty.expected
    fill_in "Received", with: @sale_empty.received
    fill_in "Sale", with: @sale_empty.sale_id
    fill_in "Variance", with: @sale_empty.variance
    click_on "Create Sale empty"

    assert_text "Sale empty was successfully created"
    click_on "Back"
  end

  test "should update Sale empty" do
    visit sale_empty_url(@sale_empty)
    click_on "Edit this sale empty", match: :first

    fill_in "Empty type", with: @sale_empty.empty_type_id
    fill_in "Expected", with: @sale_empty.expected
    fill_in "Received", with: @sale_empty.received
    fill_in "Sale", with: @sale_empty.sale_id
    fill_in "Variance", with: @sale_empty.variance
    click_on "Update Sale empty"

    assert_text "Sale empty was successfully updated"
    click_on "Back"
  end

  test "should destroy Sale empty" do
    visit sale_empty_url(@sale_empty)
    click_on "Destroy this sale empty", match: :first

    assert_text "Sale empty was successfully destroyed"
  end
end
