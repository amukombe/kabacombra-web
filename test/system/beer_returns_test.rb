require "application_system_test_case"

class BeerReturnsTest < ApplicationSystemTestCase
  setup do
    @beer_return = beer_returns(:one)
  end

  test "visiting the index" do
    visit beer_returns_url
    assert_selector "h1", text: "Beer returns"
  end

  test "should create beer return" do
    visit beer_returns_url
    click_on "New beer return"

    fill_in "Loading order", with: @beer_return.loading_order_id
    fill_in "Return date", with: @beer_return.return_date
    click_on "Create Beer return"

    assert_text "Beer return was successfully created"
    click_on "Back"
  end

  test "should update Beer return" do
    visit beer_return_url(@beer_return)
    click_on "Edit this beer return", match: :first

    fill_in "Loading order", with: @beer_return.loading_order_id
    fill_in "Return date", with: @beer_return.return_date.to_s
    click_on "Update Beer return"

    assert_text "Beer return was successfully updated"
    click_on "Back"
  end

  test "should destroy Beer return" do
    visit beer_return_url(@beer_return)
    click_on "Destroy this beer return", match: :first

    assert_text "Beer return was successfully destroyed"
  end
end
