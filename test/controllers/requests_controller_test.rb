require "test_helper"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get driver_request" do
    get requests_driver_request_url
    assert_response :success
  end
end
