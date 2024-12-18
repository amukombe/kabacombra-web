json.extract! order, :id, :order_number, :order_date, :user_id, :status_id, :total_price, :created_at, :updated_at
json.url order_url(order, format: :json)
