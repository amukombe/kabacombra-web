class BankTransfer < ApplicationRecord
  belongs_to :user
  belongs_to :territory
  belongs_to :from_account, class_name: 'BankAccount'
  belongs_to :to_account, class_name: 'BankAccount'
  validates :user_id, :territory_id, :from_account_id, :to_account_id, :transfer_date, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  before_validation :generate_transfer_ref, on: :create
  after_create :create_financial_and_bank_transaction
  private 
  def create_financial_and_bank_transaction
    ft = FinancialTransaction.create!(
      user_id: user_id,
      territory_id: territory_id,
      transaction_type: 'transfer',
      transaction_date: transfer_date,
      amount: amount,
      reference: (transfer_ref.presence || "FT#{Time.current.strftime('%Y%m%d%H%M%S')}"),
      status: 'completed'
    )
    BankTransaction.create!(
      bank_account_id: from_account_id,
      financial_transaction_id: ft.id,
      user_id: user_id,
      territory_id: territory_id,
      method: 'withdraw',
      cheque_number: nil,
      amount: amount,
      cleared_date: transfer_date,
      transaction_type: "bank_transfer"
    )
    BankTransaction.create!(
      bank_account_id: to_account_id,
      financial_transaction_id: ft.id,
      user_id: user_id,
      territory_id: territory_id,
      method: 'deposit',
      cheque_number: nil,
      amount: amount,
      cleared_date: transfer_date,
      transaction_type: "bank_transfer"
    )
  end
  def generate_transfer_ref
    self.transfer_ref ||= "BT#{Time.current.strftime('%Y%m%d%H%M%S')}"
  end
end
