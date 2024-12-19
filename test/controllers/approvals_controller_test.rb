require "test_helper"

class ApprovalsControllerTest < ActionDispatch::IntegrationTest
  test "should get loading_order" do
    get approvals_loading_order_url
    assert_response :success
  end

  test "should get epenses" do
    get approvals_epenses_url
    assert_response :success
  end
end
