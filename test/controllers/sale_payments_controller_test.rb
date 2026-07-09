require "test_helper"

class SalePaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sale_payment = sale_payments(:one)
  end

  test "should get index" do
    get sale_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_sale_payment_url
    assert_response :success
  end

  test "should create sale_payment" do
    assert_difference("SalePayment.count") do
      post sale_payments_url, params: { sale_payment: { amount: @sale_payment.amount, balance_after: @sale_payment.balance_after, balance_before: @sale_payment.balance_before, invoice_reference: @sale_payment.invoice_reference, mode_of_payment: @sale_payment.mode_of_payment, notes: @sale_payment.notes, payment_date: @sale_payment.payment_date, receipt_number: @sale_payment.receipt_number, sale_id: @sale_payment.sale_id } }
    end

    assert_redirected_to sale_payment_url(SalePayment.last)
  end

  test "should show sale_payment" do
    get sale_payment_url(@sale_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_sale_payment_url(@sale_payment)
    assert_response :success
  end

  test "should update sale_payment" do
    patch sale_payment_url(@sale_payment), params: { sale_payment: { amount: @sale_payment.amount, balance_after: @sale_payment.balance_after, balance_before: @sale_payment.balance_before, invoice_reference: @sale_payment.invoice_reference, mode_of_payment: @sale_payment.mode_of_payment, notes: @sale_payment.notes, payment_date: @sale_payment.payment_date, receipt_number: @sale_payment.receipt_number, sale_id: @sale_payment.sale_id } }
    assert_redirected_to sale_payment_url(@sale_payment)
  end

  test "should destroy sale_payment" do
    assert_difference("SalePayment.count", -1) do
      delete sale_payment_url(@sale_payment)
    end

    assert_redirected_to sale_payments_url
  end
end
