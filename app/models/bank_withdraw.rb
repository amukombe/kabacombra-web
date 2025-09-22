class BankWithdraw < ApplicationRecord
  belongs_to :bank_account
  belongs_to :user
  belongs_to :territory

  validates :withdraw_date, :amount, :withdrawn_by, :reason, :withdraw_location, presence: true
  def self.search(params, territory_id)
      params[:query].blank? ? where("territory_id=?", territory_id) : where("transaction_reference LIKE? AND territory_id=?", "%#{sanitize_sql_like(params[:query])}%", territory_id)
  end
  def self.total_withdraws(territory_id)
    where("territory_id=?", territory_id).sum(:amount)
  end

  private 
  def create_financial_and_bank_transaction
    ft = FinancialTransaction.create!(
      user_id: user_id,
      territory_id: territory_id,
      transaction_type: 'withdraw',
      transaction_date: withdraw_date,
      amount: amount,
      reference: (transaction_reference.presence || "WT#{Time.current.strftime('%Y%m%d%H%M%S')}"),
      status: 'completed'
    )
    BankTransaction.create!(
      bank_account_id: bank_account_id,
      financial_transaction_id: ft.id,
      user_id: user_id,
      territory_id: territory_id,
      method: 'withdraw',
      cheque_number: nil,
      amount: amount,
      cleared_date: withdraw_date,
      transaction_type: "bank_withdraw"
    )
  end
end
