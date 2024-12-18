require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get beer" do
    get welcome_beer_url
    assert_response :success
  end

  test "should get transport" do
    get welcome_transport_url
    assert_response :success
  end

  test "should get rentals" do
    get welcome_rentals_url
    assert_response :success
  end

  test "should get cement" do
    get welcome_cement_url
    assert_response :success
  end

  test "should get energy" do
    get welcome_energy_url
    assert_response :success
  end
end
