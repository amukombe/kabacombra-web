class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :territory
  belongs_to :bank_account
  belongs_to :payment_type
end
