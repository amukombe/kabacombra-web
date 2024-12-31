json.extract! bank_account, :id, :bank_id, :territory_id, :user_id, :account_name, :account_number, :branch_name, :branch_code, :swiftcode, :created_at, :updated_at
json.url bank_account_url(bank_account, format: :json)
