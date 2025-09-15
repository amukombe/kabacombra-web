json.extract! payment, :id, :territory_id, :user_id, :bank_account_id, :recepient_id, :recepient_type, :payment_method, :amount, :payment_date, :payment_ref, :created_at, :updated_at
json.url payment_url(payment, format: :json)
