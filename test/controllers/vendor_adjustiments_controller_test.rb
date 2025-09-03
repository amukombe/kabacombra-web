require "test_helper"

class VendorAdjustimentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vendor_adjustiment = vendor_adjustiments(:one)
  end

  test "should get index" do
    get vendor_adjustiments_url
    assert_response :success
  end

  test "should get new" do
    get new_vendor_adjustiment_url
    assert_response :success
  end

  test "should create vendor_adjustiment" do
    assert_difference("VendorAdjustiment.count") do
      post vendor_adjustiments_url, params: { vendor_adjustiment: { adjustment_date: @vendor_adjustiment.adjustment_date, purchase_type_id: @vendor_adjustiment.purchase_type_id, territory_id: @vendor_adjustiment.territory_id, user_id: @vendor_adjustiment.user_id } }
    end

    assert_redirected_to vendor_adjustiment_url(VendorAdjustiment.last)
  end

  test "should show vendor_adjustiment" do
    get vendor_adjustiment_url(@vendor_adjustiment)
    assert_response :success
  end

  test "should get edit" do
    get edit_vendor_adjustiment_url(@vendor_adjustiment)
    assert_response :success
  end

  test "should update vendor_adjustiment" do
    patch vendor_adjustiment_url(@vendor_adjustiment), params: { vendor_adjustiment: { adjustment_date: @vendor_adjustiment.adjustment_date, purchase_type_id: @vendor_adjustiment.purchase_type_id, territory_id: @vendor_adjustiment.territory_id, user_id: @vendor_adjustiment.user_id } }
    assert_redirected_to vendor_adjustiment_url(@vendor_adjustiment)
  end

  test "should destroy vendor_adjustiment" do
    assert_difference("VendorAdjustiment.count", -1) do
      delete vendor_adjustiment_url(@vendor_adjustiment)
    end

    assert_redirected_to vendor_adjustiments_url
  end
end
