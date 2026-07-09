json.extract! sale_payment, :id, :sale_id, :invoice_reference, :receipt_number, :amount, :payment_date, :mode_of_payment, :balance_before, :balance_after, :notes, :created_at, :updated_at
json.url sale_payment_url(sale_payment, format: :json)
