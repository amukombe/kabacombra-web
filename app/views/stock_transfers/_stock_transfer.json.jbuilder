json.extract! stock_transfer, :id, :transfer_type, :source_type, :source_id, :destination_type, :destination_id, :transfer_date, :description, :status, :created_at, :updated_at
json.url stock_transfer_url(stock_transfer, format: :json)
