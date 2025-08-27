class VendorPayment < ApplicationRecord
  belongs_to :territory
  belongs_to :user
end
