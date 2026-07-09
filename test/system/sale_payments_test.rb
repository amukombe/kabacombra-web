require "application_system_test_case"

class SalePaymentsTest < ApplicationSystemTestCase
  setup do
    @sale_payment = sale_payments(:one)
  end

  test "visiting the index" do
    visit sale_payments_url
    assert_selector "h1", text: "Sale payments"
  end

  test "should create sale payment" do
    visit sale_payments_url
    click_on "New sale payment"

    fill_in "Amount", with: @sale_payment.amount
    fill_in "Balance after", with: @sale_payment.balance_after
    fill_in "Balance before", with: @sale_payment.balance_before
    fill_in "Invoice reference", with: @sale_payment.invoice_reference
    fill_in "Mode of payment", with: @sale_payment.mode_of_payment
    fill_in "Notes", with: @sale_payment.notes
    fill_in "Payment date", with: @sale_payment.payment_date
    fill_in "Receipt number", with: @sale_payment.receipt_number
    fill_in "Sale", with: @sale_payment.sale_id
    click_on "Create Sale payment"

    assert_text "Sale payment was successfully created"
    click_on "Back"
  end

  test "should update Sale payment" do
    visit sale_payment_url(@sale_payment)
    click_on "Edit this sale payment", match: :first

    fill_in "Amount", with: @sale_payment.amount
    fill_in "Balance after", with: @sale_payment.balance_after
    fill_in "Balance before", with: @sale_payment.balance_before
    fill_in "Invoice reference", with: @sale_payment.invoice_reference
    fill_in "Mode of payment", with: @sale_payment.mode_of_payment
    fill_in "Notes", with: @sale_payment.notes
    fill_in "Payment date", with: @sale_payment.payment_date
    fill_in "Receipt number", with: @sale_payment.receipt_number
    fill_in "Sale", with: @sale_payment.sale_id
    click_on "Update Sale payment"

    assert_text "Sale payment was successfully updated"
    click_on "Back"
  end

  test "should destroy Sale payment" do
    visit sale_payment_url(@sale_payment)
    click_on "Destroy this sale payment", match: :first

    assert_text "Sale payment was successfully destroyed"
  end
end
