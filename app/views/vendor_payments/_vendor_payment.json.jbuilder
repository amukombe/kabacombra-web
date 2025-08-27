json.extract! vendor_payment, :id, :territory_id, :user_id, :payment_date, :journal_no, :ref_no, :payments, :suspence, :created_at, :updated_at
json.url vendor_payment_url(vendor_payment, format: :json)
