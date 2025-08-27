require "test_helper"

class StatementsControllerTest < ActionDispatch::IntegrationTest
  test "should get vendor_statement" do
    get statements_vendor_statement_url
    assert_response :success
  end
end
