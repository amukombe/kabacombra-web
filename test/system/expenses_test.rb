require "application_system_test_case"

class ExpensesTest < ApplicationSystemTestCase
  setup do
    @expense = expenses(:one)
  end

  test "visiting the index" do
    visit expenses_url
    assert_selector "h1", text: "Expenses"
  end

  test "should create expense" do
    visit expenses_url
    click_on "New expense"

    fill_in "Amount", with: @expense.amount
    fill_in "Authorized by", with: @expense.authorized_by
    fill_in "Description", with: @expense.description
    fill_in "Expense category", with: @expense.expense_category_id
    fill_in "Expense title", with: @expense.expense_title
    fill_in "Expense type", with: @expense.expense_type_id
    fill_in "Expese date", with: @expense.expese_date
    fill_in "Reason", with: @expense.reason
    fill_in "Received by", with: @expense.received_by
    fill_in "Source of income", with: @expense.source_of_income
    fill_in "Status", with: @expense.status_id
    fill_in "Territory", with: @expense.territory_id
    fill_in "User", with: @expense.user_id
    click_on "Create Expense"

    assert_text "Expense was successfully created"
    click_on "Back"
  end

  test "should update Expense" do
    visit expense_url(@expense)
    click_on "Edit this expense", match: :first

    fill_in "Amount", with: @expense.amount
    fill_in "Authorized by", with: @expense.authorized_by
    fill_in "Description", with: @expense.description
    fill_in "Expense category", with: @expense.expense_category_id
    fill_in "Expense title", with: @expense.expense_title
    fill_in "Expense type", with: @expense.expense_type_id
    fill_in "Expese date", with: @expense.expese_date
    fill_in "Reason", with: @expense.reason
    fill_in "Received by", with: @expense.received_by
    fill_in "Source of income", with: @expense.source_of_income
    fill_in "Status", with: @expense.status_id
    fill_in "Territory", with: @expense.territory_id
    fill_in "User", with: @expense.user_id
    click_on "Update Expense"

    assert_text "Expense was successfully updated"
    click_on "Back"
  end

  test "should destroy Expense" do
    visit expense_url(@expense)
    click_on "Destroy this expense", match: :first

    assert_text "Expense was successfully destroyed"
  end
end
