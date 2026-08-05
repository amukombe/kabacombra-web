require "test_helper"

class BankTransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bank_transactions_index_url
    assert_response :success
  end
end
