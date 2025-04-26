json.extract! inventory_transaction, :id, :inventory_item_id, :transaction_date, :transaction_quantity, :transaction_type, :direction, :note, :created_at, :updated_at
json.url inventory_transaction_url(inventory_transaction, format: :json)
