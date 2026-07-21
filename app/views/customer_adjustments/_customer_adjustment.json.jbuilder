json.extract! customer_adjustment, :id, :sale_id, :customer_id, :adjustment_number, :adjustment_type, :adjustment_date, :reason, :status, :subtotal, :discount_total, :tax_total, :total_amount, :applied_amount, :created_by_id, :approved_by_id, :approved_at, :created_at, :updated_at
json.url customer_adjustment_url(customer_adjustment, format: :json)
