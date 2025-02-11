require "application_system_test_case"

class PurchaseTypesTest < ApplicationSystemTestCase
  setup do
    @purchase_type = purchase_types(:one)
  end

  test "visiting the index" do
    visit purchase_types_url
    assert_selector "h1", text: "Purchase types"
  end

  test "should create purchase type" do
    visit purchase_types_url
    click_on "New purchase type"

    fill_in "Name", with: @purchase_type.name
    click_on "Create Purchase type"

    assert_text "Purchase type was successfully created"
    click_on "Back"
  end

  test "should update Purchase type" do
    visit purchase_type_url(@purchase_type)
    click_on "Edit this purchase type", match: :first

    fill_in "Name", with: @purchase_type.name
    click_on "Update Purchase type"

    assert_text "Purchase type was successfully updated"
    click_on "Back"
  end

  test "should destroy Purchase type" do
    visit purchase_type_url(@purchase_type)
    click_on "Destroy this purchase type", match: :first

    assert_text "Purchase type was successfully destroyed"
  end
end
