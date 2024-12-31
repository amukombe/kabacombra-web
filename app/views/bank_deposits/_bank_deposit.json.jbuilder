json.extract! bank_deposit, :id, :bank_account_id, :user_id, :territory_id, :deposit_date, :amount, :deposit_location, :source_of_income, :deposited_by, :transaction_reference, :additional_info, :created_at, :updated_at
json.url bank_deposit_url(bank_deposit, format: :json)
