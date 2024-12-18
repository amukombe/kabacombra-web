class Expense < ApplicationRecord
  belongs_to :expense_type
  belongs_to :user
  belongs_to :territory
  belongs_to :status

  def self.search(params)
    params[:query].blank? ? all : where("expense_title LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end
end
