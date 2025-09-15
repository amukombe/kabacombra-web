require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get banking" do
    get reports_banking_url
    assert_response :success
  end
end
