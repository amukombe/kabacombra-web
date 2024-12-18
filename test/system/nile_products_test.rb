require "application_system_test_case"

class NileProductsTest < ApplicationSystemTestCase
  setup do
    @nile_product = nile_products(:one)
  end

  test "visiting the index" do
    visit nile_products_url
    assert_selector "h1", text: "Nile products"
  end

  test "should create nile product" do
    visit nile_products_url
    click_on "New nile product"

    fill_in "Bottle size", with: @nile_product.bottle_size
    fill_in "Crate size", with: @nile_product.crate_size
    fill_in "Description", with: @nile_product.description
    fill_in "Name", with: @nile_product.name
    fill_in "Nile category", with: @nile_product.nile_category_id
    click_on "Create Nile product"

    assert_text "Nile product was successfully created"
    click_on "Back"
  end

  test "should update Nile product" do
    visit nile_product_url(@nile_product)
    click_on "Edit this nile product", match: :first

    fill_in "Bottle size", with: @nile_product.bottle_size
    fill_in "Crate size", with: @nile_product.crate_size
    fill_in "Description", with: @nile_product.description
    fill_in "Name", with: @nile_product.name
    fill_in "Nile category", with: @nile_product.nile_category_id
    click_on "Update Nile product"

    assert_text "Nile product was successfully updated"
    click_on "Back"
  end

  test "should destroy Nile product" do
    visit nile_product_url(@nile_product)
    click_on "Destroy this nile product", match: :first

    assert_text "Nile product was successfully destroyed"
  end
end
