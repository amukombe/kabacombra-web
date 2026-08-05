json.extract! bank_import_mapping, :id, :bank_id, :user_id, :date_column, :reference_column, :description_column, :debit_column, :credit_column, :balance_column, :created_at, :updated_at
json.url bank_import_mapping_url(bank_import_mapping, format: :json)
