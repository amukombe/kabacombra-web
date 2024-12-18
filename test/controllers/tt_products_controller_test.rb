require "test_helper"

class TtProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tt_product = tt_products(:one)
  end

  test "should get index" do
    get tt_products_url
    assert_response :success
  end

  test "should get new" do
    get new_tt_product_url
    assert_response :success
  end

  test "should create tt_product" do
    assert_difference("TtProduct.count") do
      post tt_products_url, params: { tt_product: { category_id: @tt_product.category_id, name: @tt_product.name } }
    end

    assert_redirected_to tt_product_url(TtProduct.last)
  end

  test "should show tt_product" do
    get tt_product_url(@tt_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_tt_product_url(@tt_product)
    assert_response :success
  end

  test "should update tt_product" do
    patch tt_product_url(@tt_product), params: { tt_product: { category_id: @tt_product.category_id, name: @tt_product.name } }
    assert_redirected_to tt_product_url(@tt_product)
  end

  test "should destroy tt_product" do
    assert_difference("TtProduct.count", -1) do
      delete tt_product_url(@tt_product)
    end

    assert_redirected_to tt_products_url
  end
end
