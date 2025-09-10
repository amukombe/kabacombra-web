json.extract! cheque, :id, :user_id, :territory_id, :bank_transaction_id, :cheque_number, :payee, :status, :issue_date, :cleared_date, :created_at, :updated_at
json.url cheque_url(cheque, format: :json)
