require "test_helper"

class CustomerCreditMemosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customer_credit_memos_index_url
    assert_response :success
  end

  test "should get show" do
    get customer_credit_memos_show_url
    assert_response :success
  end
end
