json.extract! payment, :id, :user_id, :territory_id, :financial_transaction_id, :payment_type_id, :recipient_type, :recepient_id, :amount, :payment_date, :created_at, :updated_at
json.url payment_url(payment, format: :json)
