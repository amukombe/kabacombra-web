class BankAccount < ApplicationRecord
  belongs_to :bank
  belongs_to :territory
  belongs_to :user

  validates :account_name, :account_number, presence: true
  def self.search(params, territory_id)
      params[:query].blank? ? where("territory_id=?", territory_id) : where("name LIKE? AND territory_id=?", "%#{sanitize_sql_like(params[:query])}%", territory_id)
  end
end
