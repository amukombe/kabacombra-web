require "test_helper"

class VendorPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vendor_payment = vendor_payments(:one)
  end

  test "should get index" do
    get vendor_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_vendor_payment_url
    assert_response :success
  end

  test "should create vendor_payment" do
    assert_difference("VendorPayment.count") do
      post vendor_payments_url, params: { vendor_payment: { journal_no: @vendor_payment.journal_no, payment_date: @vendor_payment.payment_date, payments: @vendor_payment.payments, ref_no: @vendor_payment.ref_no, suspence: @vendor_payment.suspence, territory_id: @vendor_payment.territory_id, user_id: @vendor_payment.user_id } }
    end

    assert_redirected_to vendor_payment_url(VendorPayment.last)
  end

  test "should show vendor_payment" do
    get vendor_payment_url(@vendor_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_vendor_payment_url(@vendor_payment)
    assert_response :success
  end

  test "should update vendor_payment" do
    patch vendor_payment_url(@vendor_payment), params: { vendor_payment: { journal_no: @vendor_payment.journal_no, payment_date: @vendor_payment.payment_date, payments: @vendor_payment.payments, ref_no: @vendor_payment.ref_no, suspence: @vendor_payment.suspence, territory_id: @vendor_payment.territory_id, user_id: @vendor_payment.user_id } }
    assert_redirected_to vendor_payment_url(@vendor_payment)
  end

  test "should destroy vendor_payment" do
    assert_difference("VendorPayment.count", -1) do
      delete vendor_payment_url(@vendor_payment)
    end

    assert_redirected_to vendor_payments_url
  end
end
