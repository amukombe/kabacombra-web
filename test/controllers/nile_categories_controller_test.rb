require "test_helper"

class NileCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nile_category = nile_categories(:one)
  end

  test "should get index" do
    get nile_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_nile_category_url
    assert_response :success
  end

  test "should create nile_category" do
    assert_difference("NileCategory.count") do
      post nile_categories_url, params: { nile_category: { description: @nile_category.description, name: @nile_category.name } }
    end

    assert_redirected_to nile_category_url(NileCategory.last)
  end

  test "should show nile_category" do
    get nile_category_url(@nile_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_nile_category_url(@nile_category)
    assert_response :success
  end

  test "should update nile_category" do
    patch nile_category_url(@nile_category), params: { nile_category: { description: @nile_category.description, name: @nile_category.name } }
    assert_redirected_to nile_category_url(@nile_category)
  end

  test "should destroy nile_category" do
    assert_difference("NileCategory.count", -1) do
      delete nile_category_url(@nile_category)
    end

    assert_redirected_to nile_categories_url
  end
end
