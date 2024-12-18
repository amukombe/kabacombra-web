json.extract! inventory_item, :id, :inventory_id, :nile_product_id, :quantity_ordered, :quantity_dispatched, :quantity_received, :quantity_sold, :purchase_price, :selling_price, :is_active, :is_closed, :is_deleted, :user_id, :manufacture_date, :expiry_date, :delivery_time, :created_at, :updated_at
json.url inventory_item_url(inventory_item, format: :json)
