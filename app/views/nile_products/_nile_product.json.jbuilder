json.extract! nile_product, :id, :name, :crate_size, :bottle_size, :description, :nile_category_id, :created_at, :updated_at
json.url nile_product_url(nile_product, format: :json)
