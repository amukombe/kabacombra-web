require "application_system_test_case"

class TtCategoriesTest < ApplicationSystemTestCase
  setup do
    @tt_category = tt_categories(:one)
  end

  test "visiting the index" do
    visit tt_categories_url
    assert_selector "h1", text: "Tt categories"
  end

  test "should create tt category" do
    visit tt_categories_url
    click_on "New tt category"

    fill_in "Name", with: @tt_category.name
    click_on "Create Tt category"

    assert_text "Tt category was successfully created"
    click_on "Back"
  end

  test "should update Tt category" do
    visit tt_category_url(@tt_category)
    click_on "Edit this tt category", match: :first

    fill_in "Name", with: @tt_category.name
    click_on "Update Tt category"

    assert_text "Tt category was successfully updated"
    click_on "Back"
  end

  test "should destroy Tt category" do
    visit tt_category_url(@tt_category)
    click_on "Destroy this tt category", match: :first

    assert_text "Tt category was successfully destroyed"
  end
end
