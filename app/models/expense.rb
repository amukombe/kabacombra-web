class Expense < ApplicationRecord
  belongs_to :expense_type
  belongs_to :user
  belongs_to :territory
  belongs_to :status

  def self.search(params, territory_id)
    params[:query].blank? ? where("territory_id=?", territory_id) : where("expense_title LIKE? AND territory_id=?", "%#{sanitize_sql_like(params[:query])}%", territory_id)
  end

  def self.my_approvals(params, territory_id, user_id, status_id)
    if params[:query].present?
      where("expense_title LIKE ? AND status_id IN (?) AND territory_id = ? AND authorized_by = ?", "%#{sanitize_sql_like(params[:query])}%", [8], territory_id, user_id)
    else
      where(status_id: 8, territory_id: territory_id, authorized_by: user_id)
    end
  end
end
