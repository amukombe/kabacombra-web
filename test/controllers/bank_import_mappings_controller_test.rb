require "test_helper"

class BankImportMappingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bank_import_mapping = bank_import_mappings(:one)
  end

  test "should get index" do
    get bank_import_mappings_url
    assert_response :success
  end

  test "should get new" do
    get new_bank_import_mapping_url
    assert_response :success
  end

  test "should create bank_import_mapping" do
    assert_difference("BankImportMapping.count") do
      post bank_import_mappings_url, params: { bank_import_mapping: { balance_column: @bank_import_mapping.balance_column, bank_id: @bank_import_mapping.bank_id, credit_column: @bank_import_mapping.credit_column, date_column: @bank_import_mapping.date_column, debit_column: @bank_import_mapping.debit_column, description_column: @bank_import_mapping.description_column, reference_column: @bank_import_mapping.reference_column, user_id: @bank_import_mapping.user_id } }
    end

    assert_redirected_to bank_import_mapping_url(BankImportMapping.last)
  end

  test "should show bank_import_mapping" do
    get bank_import_mapping_url(@bank_import_mapping)
    assert_response :success
  end

  test "should get edit" do
    get edit_bank_import_mapping_url(@bank_import_mapping)
    assert_response :success
  end

  test "should update bank_import_mapping" do
    patch bank_import_mapping_url(@bank_import_mapping), params: { bank_import_mapping: { balance_column: @bank_import_mapping.balance_column, bank_id: @bank_import_mapping.bank_id, credit_column: @bank_import_mapping.credit_column, date_column: @bank_import_mapping.date_column, debit_column: @bank_import_mapping.debit_column, description_column: @bank_import_mapping.description_column, reference_column: @bank_import_mapping.reference_column, user_id: @bank_import_mapping.user_id } }
    assert_redirected_to bank_import_mapping_url(@bank_import_mapping)
  end

  test "should destroy bank_import_mapping" do
    assert_difference("BankImportMapping.count", -1) do
      delete bank_import_mapping_url(@bank_import_mapping)
    end

    assert_redirected_to bank_import_mappings_url
  end
end
