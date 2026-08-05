require "test_helper"

class BankStatementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bank_statements_index_url
    assert_response :success
  end
end
