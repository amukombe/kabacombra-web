require "application_system_test_case"

class CarMakesTest < ApplicationSystemTestCase
  setup do
    @car_make = car_makes(:one)
  end

  test "visiting the index" do
    visit car_makes_url
    assert_selector "h1", text: "Car makes"
  end

  test "should create car make" do
    visit car_makes_url
    click_on "New car make"

    fill_in "Name", with: @car_make.name
    click_on "Create Car make"

    assert_text "Car make was successfully created"
    click_on "Back"
  end

  test "should update Car make" do
    visit car_make_url(@car_make)
    click_on "Edit this car make", match: :first

    fill_in "Name", with: @car_make.name
    click_on "Update Car make"

    assert_text "Car make was successfully updated"
    click_on "Back"
  end

  test "should destroy Car make" do
    visit car_make_url(@car_make)
    click_on "Destroy this car make", match: :first

    assert_text "Car make was successfully destroyed"
  end
end
