class BankWithdraw < ApplicationRecord
  belongs_to :bank_account
  belongs_to :user
  belongs_to :territory

  validates :withdraw_date, :amount, :withdrawn_by, :reason, :withdraw_location, presence: true
  def self.search(params, territory_id)
      params[:query].blank? ? where("territory_id=?", territory_id) : where("transaction_reference LIKE? AND territory_id=?", "%#{sanitize_sql_like(params[:query])}%", territory_id)
  end
end
