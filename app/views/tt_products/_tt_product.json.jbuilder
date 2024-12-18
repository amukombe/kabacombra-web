json.extract! tt_product, :id, :name, :category_id, :created_at, :updated_at
json.url tt_product_url(tt_product, format: :json)
