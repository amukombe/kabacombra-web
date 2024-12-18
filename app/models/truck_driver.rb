class TruckDriver < ApplicationRecord
  belongs_to :truck
  belongs_to :driver
  belongs_to :user
end
