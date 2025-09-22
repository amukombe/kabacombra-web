class FinancialTransaction < ApplicationRecord
  # transaction_type: ['income', 'expense', 'transfer']
  belongs_to :user
  belongs_to :territory
end
