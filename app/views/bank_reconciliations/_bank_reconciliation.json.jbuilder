json.extract! bank_reconciliation, :id, :territory_id, :user_id, :bank_account_id, :statement_from, :statement_to, :book_balance, :bank_balance, :difference, :status, :reference, :reconciled_at, :created_at, :updated_at
json.url bank_reconciliation_url(bank_reconciliation, format: :json)
