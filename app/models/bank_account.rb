class BankAccount < ApplicationRecord
  belongs_to :bank
  belongs_to :territory
  belongs_to :user
  has_many :payments, dependent: :destroy
  has_many :bank_transactions, dependent: :destroy
  validates :account_name, :account_number, presence: true
  def self.search(params, territory_id)
      params[:query].blank? ? where("territory_id=?", territory_id) : where("name LIKE? AND territory_id=?", "%#{sanitize_sql_like(params[:query])}%", territory_id)
  end

  def display_name
    return "#{account_name} - #{account_number}"
  end

  def balance
    deposits = bank_transactions.where(method: 'deposit').sum(:amount)
    withdraws = bank_transactions.where(method: 'withdraw').sum(:amount)
    return (deposits - withdraws)
  end
end
