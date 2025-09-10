class FinancialTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :territory
end
