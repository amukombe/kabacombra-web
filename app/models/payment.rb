class Payment < ApplicationRecord
  belongs_to :territory
  belongs_to :user
  belongs_to :bank_account
  belongs_to :recipient, polymorphic: true
  enum payment_method: { cash: 0, cheque: 1, mobile_money: 2, bank_transfer: 3 }
  validates :territory_id, :user_id, :bank_account_id, :recipient_id, :recipient_type, :payment_method, :amount, :payment_date, presence: true
  validates :amount, numericality: { greater_than: 0 }
  after_create :create_related_transactions

  private

  def create_related_transactions
    create_financial_transaction
    create_vendor_payment_if_supplier
  end
  def create_financial_transaction
    ft = FinancialTransaction.create!(
      user_id: user_id,
      territory_id: territory_id,
      transaction_type: 'payment',
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
      method: "withdraw",
      cheque_number: (payment_method == 'cheque' ? payment_no : nil),
      amount: amount,
      cleared_date: payment_date,
      transaction_type: "bank_withdraw"
    )
  end

  def create_vendor_payment_if_supplier
    return unless recipient_type == "Supplier"

    vendor_payment =
      VendorPayment.create!(
        territory: territory,
        user: user,

        payment_date: payment_date.to_date,

        payment_method: payment_method,

        amount: amount,

        ref_no: payment_ref,

        journal_no: payment_no,

        notes: "Created automatically from Payment #{payment_no}"
      )

    VendorAdjustiments::GenerateIncentives
      .new(vendor_payment)
      .call
  end
end
