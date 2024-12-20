json.extract! sale_item, :id, :loading_order_item_id, :quantity_sold, :amount, :total, :created_at, :updated_at
json.url sale_item_url(sale_item, format: :json)
