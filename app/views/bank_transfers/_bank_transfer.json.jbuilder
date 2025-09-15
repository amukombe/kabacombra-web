json.extract! bank_transfer, :id, :user_id, :territory_id, :from_account_id, :to_account_id, :transfer_date, :amount, :reason, :transfer_ref, :created_at, :updated_at
json.url bank_transfer_url(bank_transfer, format: :json)
