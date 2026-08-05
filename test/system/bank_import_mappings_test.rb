require "application_system_test_case"

class BankImportMappingsTest < ApplicationSystemTestCase
  setup do
    @bank_import_mapping = bank_import_mappings(:one)
  end

  test "visiting the index" do
    visit bank_import_mappings_url
    assert_selector "h1", text: "Bank import mappings"
  end

  test "should create bank import mapping" do
    visit bank_import_mappings_url
    click_on "New bank import mapping"

    fill_in "Balance column", with: @bank_import_mapping.balance_column
    fill_in "Bank", with: @bank_import_mapping.bank_id
    fill_in "Credit column", with: @bank_import_mapping.credit_column
    fill_in "Date column", with: @bank_import_mapping.date_column
    fill_in "Debit column", with: @bank_import_mapping.debit_column
    fill_in "Description column", with: @bank_import_mapping.description_column
    fill_in "Reference column", with: @bank_import_mapping.reference_column
    fill_in "User", with: @bank_import_mapping.user_id
    click_on "Create Bank import mapping"

    assert_text "Bank import mapping was successfully created"
    click_on "Back"
  end

  test "should update Bank import mapping" do
    visit bank_import_mapping_url(@bank_import_mapping)
    click_on "Edit this bank import mapping", match: :first

    fill_in "Balance column", with: @bank_import_mapping.balance_column
    fill_in "Bank", with: @bank_import_mapping.bank_id
    fill_in "Credit column", with: @bank_import_mapping.credit_column
    fill_in "Date column", with: @bank_import_mapping.date_column
    fill_in "Debit column", with: @bank_import_mapping.debit_column
    fill_in "Description column", with: @bank_import_mapping.description_column
    fill_in "Reference column", with: @bank_import_mapping.reference_column
    fill_in "User", with: @bank_import_mapping.user_id
    click_on "Update Bank import mapping"

    assert_text "Bank import mapping was successfully updated"
    click_on "Back"
  end

  test "should destroy Bank import mapping" do
    visit bank_import_mapping_url(@bank_import_mapping)
    click_on "Destroy this bank import mapping", match: :first

    assert_text "Bank import mapping was successfully destroyed"
  end
end
