class BankTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :territory
  belongs_to :financial_transaction
  belongs_to :bank_account
end
