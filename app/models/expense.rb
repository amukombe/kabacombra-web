class Expense < ApplicationRecord
  belongs_to :expense_type
  belongs_to :user
  belongs_to :territory
  belongs_to :status
end
