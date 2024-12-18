require "application_system_test_case"

class TruckTypesTest < ApplicationSystemTestCase
  setup do
    @truck_type = truck_types(:one)
  end

  test "visiting the index" do
    visit truck_types_url
    assert_selector "h1", text: "Truck types"
  end

  test "should create truck type" do
    visit truck_types_url
    click_on "New truck type"

    fill_in "Description", with: @truck_type.description
    fill_in "Name", with: @truck_type.name
    click_on "Create Truck type"

    assert_text "Truck type was successfully created"
    click_on "Back"
  end

  test "should update Truck type" do
    visit truck_type_url(@truck_type)
    click_on "Edit this truck type", match: :first

    fill_in "Description", with: @truck_type.description
    fill_in "Name", with: @truck_type.name
    click_on "Update Truck type"

    assert_text "Truck type was successfully updated"
    click_on "Back"
  end

  test "should destroy Truck type" do
    visit truck_type_url(@truck_type)
    click_on "Destroy this truck type", match: :first

    assert_text "Truck type was successfully destroyed"
  end
end
