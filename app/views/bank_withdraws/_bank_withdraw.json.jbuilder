json.extract! bank_withdraw, :id, :bank_account_id, :user_id, :territory_id, :withdraw_date, :amount, :withdraw_location, :reason, :withdrawn_by, :transaction_reference, :additional_info, :created_at, :updated_at
json.url bank_withdraw_url(bank_withdraw, format: :json)
