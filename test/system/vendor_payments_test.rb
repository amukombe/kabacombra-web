require "application_system_test_case"

class VendorPaymentsTest < ApplicationSystemTestCase
  setup do
    @vendor_payment = vendor_payments(:one)
  end

  test "visiting the index" do
    visit vendor_payments_url
    assert_selector "h1", text: "Vendor payments"
  end

  test "should create vendor payment" do
    visit vendor_payments_url
    click_on "New vendor payment"

    fill_in "Journal no", with: @vendor_payment.journal_no
    fill_in "Payment date", with: @vendor_payment.payment_date
    fill_in "Payments", with: @vendor_payment.payments
    fill_in "Ref no", with: @vendor_payment.ref_no
    fill_in "Suspence", with: @vendor_payment.suspence
    fill_in "Territory", with: @vendor_payment.territory_id
    fill_in "User", with: @vendor_payment.user_id
    click_on "Create Vendor payment"

    assert_text "Vendor payment was successfully created"
    click_on "Back"
  end

  test "should update Vendor payment" do
    visit vendor_payment_url(@vendor_payment)
    click_on "Edit this vendor payment", match: :first

    fill_in "Journal no", with: @vendor_payment.journal_no
    fill_in "Payment date", with: @vendor_payment.payment_date
    fill_in "Payments", with: @vendor_payment.payments
    fill_in "Ref no", with: @vendor_payment.ref_no
    fill_in "Suspence", with: @vendor_payment.suspence
    fill_in "Territory", with: @vendor_payment.territory_id
    fill_in "User", with: @vendor_payment.user_id
    click_on "Update Vendor payment"

    assert_text "Vendor payment was successfully updated"
    click_on "Back"
  end

  test "should destroy Vendor payment" do
    visit vendor_payment_url(@vendor_payment)
    click_on "Destroy this vendor payment", match: :first

    assert_text "Vendor payment was successfully destroyed"
  end
end
