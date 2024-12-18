json.extract! loading_order, :id, :driver_id, :user_id, :territory_id, :vehicle_numperplate, :destination, :loading_date, :order_number, :sales_man, :authorized_by, :verified_by, :created_at, :updated_at
json.url loading_order_url(loading_order, format: :json)
