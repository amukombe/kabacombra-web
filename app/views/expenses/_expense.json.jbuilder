json.extract! expense, :id, :expense_type_id, :expense_category_id, :user_id, :territory_id, :status_id, :expense_title, :received_by, :authorized_by, :reason, :description, :expese_date, :amount, :source_of_income, :created_at, :updated_at
json.url expense_url(expense, format: :json)
