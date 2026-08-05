json.extract! bank_reconciliation_item, :id, :bank_reconciliation_id, :bank_transaction_id, :bank_date, :bank_reference, :description, :bank_amount, :matched, :cleared, :notes, :created_at, :updated_at
json.url bank_reconciliation_item_url(bank_reconciliation_item, format: :json)
