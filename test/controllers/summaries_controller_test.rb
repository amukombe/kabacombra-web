require "test_helper"

class SummariesControllerTest < ActionDispatch::IntegrationTest
  test "should get banking" do
    get summaries_banking_url
    assert_response :success
  end
end
