require "application_system_test_case"

class TtProductsTest < ApplicationSystemTestCase
  setup do
    @tt_product = tt_products(:one)
  end

  test "visiting the index" do
    visit tt_products_url
    assert_selector "h1", text: "Tt products"
  end

  test "should create tt product" do
    visit tt_products_url
    click_on "New tt product"

    fill_in "Category", with: @tt_product.category_id
    fill_in "Name", with: @tt_product.name
    click_on "Create Tt product"

    assert_text "Tt product was successfully created"
    click_on "Back"
  end

  test "should update Tt product" do
    visit tt_product_url(@tt_product)
    click_on "Edit this tt product", match: :first

    fill_in "Category", with: @tt_product.category_id
    fill_in "Name", with: @tt_product.name
    click_on "Update Tt product"

    assert_text "Tt product was successfully updated"
    click_on "Back"
  end

  test "should destroy Tt product" do
    visit tt_product_url(@tt_product)
    click_on "Destroy this tt product", match: :first

    assert_text "Tt product was successfully destroyed"
  end
end
