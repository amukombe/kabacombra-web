require "application_system_test_case"

class EmptyTypesTest < ApplicationSystemTestCase
  setup do
    @empty_type = empty_types(:one)
  end

  test "visiting the index" do
    visit empty_types_url
    assert_selector "h1", text: "Empty types"
  end

  test "should create empty type" do
    visit empty_types_url
    click_on "New empty type"

    fill_in "Name", with: @empty_type.name
    fill_in "Price", with: @empty_type.price
    click_on "Create Empty type"

    assert_text "Empty type was successfully created"
    click_on "Back"
  end

  test "should update Empty type" do
    visit empty_type_url(@empty_type)
    click_on "Edit this empty type", match: :first

    fill_in "Name", with: @empty_type.name
    fill_in "Price", with: @empty_type.price
    click_on "Update Empty type"

    assert_text "Empty type was successfully updated"
    click_on "Back"
  end

  test "should destroy Empty type" do
    visit empty_type_url(@empty_type)
    click_on "Destroy this empty type", match: :first

    assert_text "Empty type was successfully destroyed"
  end
end
