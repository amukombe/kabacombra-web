require "test_helper"

class NileProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nile_product = nile_products(:one)
  end

  test "should get index" do
    get nile_products_url
    assert_response :success
  end

  test "should get new" do
    get new_nile_product_url
    assert_response :success
  end

  test "should create nile_product" do
    assert_difference("NileProduct.count") do
      post nile_products_url, params: { nile_product: { bottle_size: @nile_product.bottle_size, crate_size: @nile_product.crate_size, description: @nile_product.description, name: @nile_product.name, nile_category_id: @nile_product.nile_category_id } }
    end

    assert_redirected_to nile_product_url(NileProduct.last)
  end

  test "should show nile_product" do
    get nile_product_url(@nile_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_nile_product_url(@nile_product)
    assert_response :success
  end

  test "should update nile_product" do
    patch nile_product_url(@nile_product), params: { nile_product: { bottle_size: @nile_product.bottle_size, crate_size: @nile_product.crate_size, description: @nile_product.description, name: @nile_product.name, nile_category_id: @nile_product.nile_category_id } }
    assert_redirected_to nile_product_url(@nile_product)
  end

  test "should destroy nile_product" do
    assert_difference("NileProduct.count", -1) do
      delete nile_product_url(@nile_product)
    end

    assert_redirected_to nile_products_url
  end
end
