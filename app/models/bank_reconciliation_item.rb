class BankReconciliationItem < ApplicationRecord
  belongs_to :bank_reconciliation

  belongs_to :bank_transaction, optional: true

  belongs_to :matched_transaction,
             class_name: "BankTransaction",
             optional: true

  scope :matched, -> { where(matched: true) }

  scope :unmatched, -> { where(matched: false) }

  validates :bank_amount, numericality: true, allow_nil: true
end