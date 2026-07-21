require "test_helper"

class CustomerAdjustmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_adjustment = customer_adjustments(:one)
  end

  test "should get index" do
    get customer_adjustments_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_adjustment_url
    assert_response :success
  end

  test "should create customer_adjustment" do
    assert_difference("CustomerAdjustment.count") do
      post customer_adjustments_url, params: { customer_adjustment: { adjustment_date: @customer_adjustment.adjustment_date, adjustment_number: @customer_adjustment.adjustment_number, adjustment_type: @customer_adjustment.adjustment_type, applied_amount: @customer_adjustment.applied_amount, approved_at: @customer_adjustment.approved_at, approved_by_id: @customer_adjustment.approved_by_id, created_by_id: @customer_adjustment.created_by_id, customer_id: @customer_adjustment.customer_id, discount_total: @customer_adjustment.discount_total, reason: @customer_adjustment.reason, sale_id: @customer_adjustment.sale_id, status: @customer_adjustment.status, subtotal: @customer_adjustment.subtotal, tax_total: @customer_adjustment.tax_total, total_amount: @customer_adjustment.total_amount } }
    end

    assert_redirected_to customer_adjustment_url(CustomerAdjustment.last)
  end

  test "should show customer_adjustment" do
    get customer_adjustment_url(@customer_adjustment)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_adjustment_url(@customer_adjustment)
    assert_response :success
  end

  test "should update customer_adjustment" do
    patch customer_adjustment_url(@customer_adjustment), params: { customer_adjustment: { adjustment_date: @customer_adjustment.adjustment_date, adjustment_number: @customer_adjustment.adjustment_number, adjustment_type: @customer_adjustment.adjustment_type, applied_amount: @customer_adjustment.applied_amount, approved_at: @customer_adjustment.approved_at, approved_by_id: @customer_adjustment.approved_by_id, created_by_id: @customer_adjustment.created_by_id, customer_id: @customer_adjustment.customer_id, discount_total: @customer_adjustment.discount_total, reason: @customer_adjustment.reason, sale_id: @customer_adjustment.sale_id, status: @customer_adjustment.status, subtotal: @customer_adjustment.subtotal, tax_total: @customer_adjustment.tax_total, total_amount: @customer_adjustment.total_amount } }
    assert_redirected_to customer_adjustment_url(@customer_adjustment)
  end

  test "should destroy customer_adjustment" do
    assert_difference("CustomerAdjustment.count", -1) do
      delete customer_adjustment_url(@customer_adjustment)
    end

    assert_redirected_to customer_adjustments_url
  end
end
