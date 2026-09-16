class LoadingOrderAllocation < ApplicationRecord
  belongs_to :loading_order
  belongs_to :loading_order_item
  belongs_to :inventory_item
end
