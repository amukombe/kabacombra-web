require "application_system_test_case"

class CustomerAdjustmentsTest < ApplicationSystemTestCase
  setup do
    @customer_adjustment = customer_adjustments(:one)
  end

  test "visiting the index" do
    visit customer_adjustments_url
    assert_selector "h1", text: "Customer adjustments"
  end

  test "should create customer adjustment" do
    visit customer_adjustments_url
    click_on "New customer adjustment"

    fill_in "Adjustment date", with: @customer_adjustment.adjustment_date
    fill_in "Adjustment number", with: @customer_adjustment.adjustment_number
    fill_in "Adjustment type", with: @customer_adjustment.adjustment_type
    fill_in "Applied amount", with: @customer_adjustment.applied_amount
    fill_in "Approved at", with: @customer_adjustment.approved_at
    fill_in "Approved by", with: @customer_adjustment.approved_by_id
    fill_in "Created by", with: @customer_adjustment.created_by_id
    fill_in "Customer", with: @customer_adjustment.customer_id
    fill_in "Discount total", with: @customer_adjustment.discount_total
    fill_in "Reason", with: @customer_adjustment.reason
    fill_in "Sale", with: @customer_adjustment.sale_id
    fill_in "Status", with: @customer_adjustment.status
    fill_in "Subtotal", with: @customer_adjustment.subtotal
    fill_in "Tax total", with: @customer_adjustment.tax_total
    fill_in "Total amount", with: @customer_adjustment.total_amount
    click_on "Create Customer adjustment"

    assert_text "Customer adjustment was successfully created"
    click_on "Back"
  end

  test "should update Customer adjustment" do
    visit customer_adjustment_url(@customer_adjustment)
    click_on "Edit this customer adjustment", match: :first

    fill_in "Adjustment date", with: @customer_adjustment.adjustment_date
    fill_in "Adjustment number", with: @customer_adjustment.adjustment_number
    fill_in "Adjustment type", with: @customer_adjustment.adjustment_type
    fill_in "Applied amount", with: @customer_adjustment.applied_amount
    fill_in "Approved at", with: @customer_adjustment.approved_at.to_s
    fill_in "Approved by", with: @customer_adjustment.approved_by_id
    fill_in "Created by", with: @customer_adjustment.created_by_id
    fill_in "Customer", with: @customer_adjustment.customer_id
    fill_in "Discount total", with: @customer_adjustment.discount_total
    fill_in "Reason", with: @customer_adjustment.reason
    fill_in "Sale", with: @customer_adjustment.sale_id
    fill_in "Status", with: @customer_adjustment.status
    fill_in "Subtotal", with: @customer_adjustment.subtotal
    fill_in "Tax total", with: @customer_adjustment.tax_total
    fill_in "Total amount", with: @customer_adjustment.total_amount
    click_on "Update Customer adjustment"

    assert_text "Customer adjustment was successfully updated"
    click_on "Back"
  end

  test "should destroy Customer adjustment" do
    visit customer_adjustment_url(@customer_adjustment)
    click_on "Destroy this customer adjustment", match: :first

    assert_text "Customer adjustment was successfully destroyed"
  end
end
