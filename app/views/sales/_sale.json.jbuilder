json.extract! sale, :id, :loading_order_item_id, :customer_id, :user_id, :quantity_sold, :amount, :total, :sale_type, :mode_of_payment, :created_at, :updated_at
json.url sale_url(sale, format: :json)
