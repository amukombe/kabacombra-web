require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expense = expenses(:one)
  end

  test "should get index" do
    get expenses_url
    assert_response :success
  end

  test "should get new" do
    get new_expense_url
    assert_response :success
  end

  test "should create expense" do
    assert_difference("Expense.count") do
      post expenses_url, params: { expense: { amount: @expense.amount, authorized_by: @expense.authorized_by, description: @expense.description, expense_category_id: @expense.expense_category_id, expense_title: @expense.expense_title, expense_type_id: @expense.expense_type_id, expese_date: @expense.expese_date, reason: @expense.reason, received_by: @expense.received_by, source_of_income: @expense.source_of_income, status_id: @expense.status_id, territory_id: @expense.territory_id, user_id: @expense.user_id } }
    end

    assert_redirected_to expense_url(Expense.last)
  end

  test "should show expense" do
    get expense_url(@expense)
    assert_response :success
  end

  test "should get edit" do
    get edit_expense_url(@expense)
    assert_response :success
  end

  test "should update expense" do
    patch expense_url(@expense), params: { expense: { amount: @expense.amount, authorized_by: @expense.authorized_by, description: @expense.description, expense_category_id: @expense.expense_category_id, expense_title: @expense.expense_title, expense_type_id: @expense.expense_type_id, expese_date: @expense.expese_date, reason: @expense.reason, received_by: @expense.received_by, source_of_income: @expense.source_of_income, status_id: @expense.status_id, territory_id: @expense.territory_id, user_id: @expense.user_id } }
    assert_redirected_to expense_url(@expense)
  end

  test "should destroy expense" do
    assert_difference("Expense.count", -1) do
      delete expense_url(@expense)
    end

    assert_redirected_to expenses_url
  end
end
