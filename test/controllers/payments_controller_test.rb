require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment = payments(:one)
  end

  test "should get index" do
    get payments_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_url
    assert_response :success
  end

  test "should create payment" do
    assert_difference("Payment.count") do
      post payments_url, params: { payment: { amount: @payment.amount, bank_account_id: @payment.bank_account_id, payment_date: @payment.payment_date, payment_method: @payment.payment_method, payment_ref: @payment.payment_ref, recepient_id: @payment.recepient_id, recepient_type: @payment.recepient_type, territory_id: @payment.territory_id, user_id: @payment.user_id } }
    end

    assert_redirected_to payment_url(Payment.last)
  end

  test "should show payment" do
    get payment_url(@payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_url(@payment)
    assert_response :success
  end

  test "should update payment" do
    patch payment_url(@payment), params: { payment: { amount: @payment.amount, bank_account_id: @payment.bank_account_id, payment_date: @payment.payment_date, payment_method: @payment.payment_method, payment_ref: @payment.payment_ref, recepient_id: @payment.recepient_id, recepient_type: @payment.recepient_type, territory_id: @payment.territory_id, user_id: @payment.user_id } }
    assert_redirected_to payment_url(@payment)
  end

  test "should destroy payment" do
    assert_difference("Payment.count", -1) do
      delete payment_url(@payment)
    end

    assert_redirected_to payments_url
  end
end
