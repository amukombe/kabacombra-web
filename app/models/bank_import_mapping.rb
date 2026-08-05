class BankImportMapping < ApplicationRecord
  belongs_to :bank
  belongs_to :user

  validates :date_column, presence: true
  validates :reference_column, presence: true
  validates :description_column, presence: true
  validates :debit_column, presence: true
  validates :credit_column, presence: true
  validates :balance_column, presence: true
end
