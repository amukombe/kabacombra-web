require "application_system_test_case"

class VendorAdjustimentsTest < ApplicationSystemTestCase
  setup do
    @vendor_adjustiment = vendor_adjustiments(:one)
  end

  test "visiting the index" do
    visit vendor_adjustiments_url
    assert_selector "h1", text: "Vendor adjustiments"
  end

  test "should create vendor adjustiment" do
    visit vendor_adjustiments_url
    click_on "New vendor adjustiment"

    fill_in "Adjustment date", with: @vendor_adjustiment.adjustment_date
    fill_in "Purchase type", with: @vendor_adjustiment.purchase_type_id
    fill_in "Territory", with: @vendor_adjustiment.territory_id
    fill_in "User", with: @vendor_adjustiment.user_id
    click_on "Create Vendor adjustiment"

    assert_text "Vendor adjustiment was successfully created"
    click_on "Back"
  end

  test "should update Vendor adjustiment" do
    visit vendor_adjustiment_url(@vendor_adjustiment)
    click_on "Edit this vendor adjustiment", match: :first

    fill_in "Adjustment date", with: @vendor_adjustiment.adjustment_date
    fill_in "Purchase type", with: @vendor_adjustiment.purchase_type_id
    fill_in "Territory", with: @vendor_adjustiment.territory_id
    fill_in "User", with: @vendor_adjustiment.user_id
    click_on "Update Vendor adjustiment"

    assert_text "Vendor adjustiment was successfully updated"
    click_on "Back"
  end

  test "should destroy Vendor adjustiment" do
    visit vendor_adjustiment_url(@vendor_adjustiment)
    click_on "Destroy this vendor adjustiment", match: :first

    assert_text "Vendor adjustiment was successfully destroyed"
  end
end
