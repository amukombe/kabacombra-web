class ExpenseType < ApplicationRecord
  belongs_to :expense_category
  has_many :expenses
  validates :name, uniqueness: true, presence: true
  def self.search(params)
      params[:query].blank? ? all : where("name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end
end
