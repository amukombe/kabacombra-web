require "test_helper"

class DriversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @driver = drivers(:one)
  end

  test "should get index" do
    get drivers_url
    assert_response :success
  end

  test "should get new" do
    get new_driver_url
    assert_response :success
  end

  test "should create driver" do
    assert_difference("Driver.count") do
      post drivers_url, params: { driver: { employee_id: @driver.employee_id, expiry_date: @driver.expiry_date, issued_by: @driver.issued_by, issued_date: @driver.issued_date, license_class: @driver.license_class, license_number: @driver.license_number } }
    end

    assert_redirected_to driver_url(Driver.last)
  end

  test "should show driver" do
    get driver_url(@driver)
    assert_response :success
  end

  test "should get edit" do
    get edit_driver_url(@driver)
    assert_response :success
  end

  test "should update driver" do
    patch driver_url(@driver), params: { driver: { employee_id: @driver.employee_id, expiry_date: @driver.expiry_date, issued_by: @driver.issued_by, issued_date: @driver.issued_date, license_class: @driver.license_class, license_number: @driver.license_number } }
    assert_redirected_to driver_url(@driver)
  end

  test "should destroy driver" do
    assert_difference("Driver.count", -1) do
      delete driver_url(@driver)
    end

    assert_redirected_to drivers_url
  end
end
