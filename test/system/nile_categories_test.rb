require "application_system_test_case"

class NileCategoriesTest < ApplicationSystemTestCase
  setup do
    @nile_category = nile_categories(:one)
  end

  test "visiting the index" do
    visit nile_categories_url
    assert_selector "h1", text: "Nile categories"
  end

  test "should create nile category" do
    visit nile_categories_url
    click_on "New nile category"

    fill_in "Description", with: @nile_category.description
    fill_in "Name", with: @nile_category.name
    click_on "Create Nile category"

    assert_text "Nile category was successfully created"
    click_on "Back"
  end

  test "should update Nile category" do
    visit nile_category_url(@nile_category)
    click_on "Edit this nile category", match: :first

    fill_in "Description", with: @nile_category.description
    fill_in "Name", with: @nile_category.name
    click_on "Update Nile category"

    assert_text "Nile category was successfully updated"
    click_on "Back"
  end

  test "should destroy Nile category" do
    visit nile_category_url(@nile_category)
    click_on "Destroy this nile category", match: :first

    assert_text "Nile category was successfully destroyed"
  end
end
