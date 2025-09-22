class BankTransaction < ApplicationRecord
  # method: ['deposit', 'withdraw'], transaction_type: ['bank_deposit', 'bank_withdraw', 'bank_transfer']
  belongs_to :user
  belongs_to :territory
  belongs_to :financial_transaction
  belongs_to :bank_account
end
