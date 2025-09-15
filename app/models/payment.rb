class Payment < ApplicationRecord
  belongs_to :territory
  belongs_to :user
  belongs_to :bank_account
  belongs_to :recipient, polymorphic: true
  enum payment_method: { cash: 0, cheque: 1, mobile_money: 2, bank_transfer: 3 }
  validates :territory_id, :user_id, :bank_account_id, :recipient_id, :recipient_type, :payment_method, :amount, :payment_date, presence: true
  validates :amount, numericality: { greater_than: 0 }
  after_create :create_financial_and_bank_transaction

  private
  def create_financial_and_bank_transaction
    ft = FinancialTransaction.create!(
      user_id: user_id,
      territory_id: territory_id,
      transaction_type: 'withdraw',
      transaction_date: payment_date,
      amount: amount,
      reference: (payment_ref.presence || "FT#{Time.current.strftime('%Y%m%d%H%M%S')}"),
      status: 'completed'
    )

    BankTransaction.create!(
      bank_account_id: bank_account_id,
      financial_transaction_id: ft.id,
      user_id: user_id,
      territory_id: territory_id,
      method: payment_method,
      cheque_number: (payment_method == 'cheque' ? payment_no : nil),
      amount: amount,
      cleared_date: payment_date,
      transaction_type: "withdraw"
    )
  end
end
