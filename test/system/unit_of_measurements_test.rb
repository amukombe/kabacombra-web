require "application_system_test_case"

class UnitOfMeasurementsTest < ApplicationSystemTestCase
  setup do
    @unit_of_measurement = unit_of_measurements(:one)
  end

  test "visiting the index" do
    visit unit_of_measurements_url
    assert_selector "h1", text: "Unit of measurements"
  end

  test "should create unit of measurement" do
    visit unit_of_measurements_url
    click_on "New unit of measurement"

    fill_in "Code", with: @unit_of_measurement.code
    fill_in "Name", with: @unit_of_measurement.name
    click_on "Create Unit of measurement"

    assert_text "Unit of measurement was successfully created"
    click_on "Back"
  end

  test "should update Unit of measurement" do
    visit unit_of_measurement_url(@unit_of_measurement)
    click_on "Edit this unit of measurement", match: :first

    fill_in "Code", with: @unit_of_measurement.code
    fill_in "Name", with: @unit_of_measurement.name
    click_on "Update Unit of measurement"

    assert_text "Unit of measurement was successfully updated"
    click_on "Back"
  end

  test "should destroy Unit of measurement" do
    visit unit_of_measurement_url(@unit_of_measurement)
    click_on "Destroy this unit of measurement", match: :first

    assert_text "Unit of measurement was successfully destroyed"
  end
end
