require "application_system_test_case"

class ExpenseTypesTest < ApplicationSystemTestCase
  setup do
    @expense_type = expense_types(:one)
  end

  test "visiting the index" do
    visit expense_types_url
    assert_selector "h1", text: "Expense types"
  end

  test "should create expense type" do
    visit expense_types_url
    click_on "New expense type"

    fill_in "Expense category", with: @expense_type.expense_category_id
    fill_in "Name", with: @expense_type.name
    click_on "Create Expense type"

    assert_text "Expense type was successfully created"
    click_on "Back"
  end

  test "should update Expense type" do
    visit expense_type_url(@expense_type)
    click_on "Edit this expense type", match: :first

    fill_in "Expense category", with: @expense_type.expense_category_id
    fill_in "Name", with: @expense_type.name
    click_on "Update Expense type"

    assert_text "Expense type was successfully updated"
    click_on "Back"
  end

  test "should destroy Expense type" do
    visit expense_type_url(@expense_type)
    click_on "Destroy this expense type", match: :first

    assert_text "Expense type was successfully destroyed"
  end
end
