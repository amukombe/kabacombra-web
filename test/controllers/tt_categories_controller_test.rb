require "test_helper"

class TtCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tt_category = tt_categories(:one)
  end

  test "should get index" do
    get tt_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_tt_category_url
    assert_response :success
  end

  test "should create tt_category" do
    assert_difference("TtCategory.count") do
      post tt_categories_url, params: { tt_category: { name: @tt_category.name } }
    end

    assert_redirected_to tt_category_url(TtCategory.last)
  end

  test "should show tt_category" do
    get tt_category_url(@tt_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_tt_category_url(@tt_category)
    assert_response :success
  end

  test "should update tt_category" do
    patch tt_category_url(@tt_category), params: { tt_category: { name: @tt_category.name } }
    assert_redirected_to tt_category_url(@tt_category)
  end

  test "should destroy tt_category" do
    assert_difference("TtCategory.count", -1) do
      delete tt_category_url(@tt_category)
    end

    assert_redirected_to tt_categories_url
  end
end
