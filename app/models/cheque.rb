class Cheque < ApplicationRecord
  belongs_to :user
  belongs_to :territory
  belongs_to :bank_transaction
end
