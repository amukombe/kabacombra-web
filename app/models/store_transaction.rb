class StoreTransaction < ApplicationRecord
  belongs_to :nile_product
  belongs_to :territory
  belongs_to :user
  #belongs_to :loading_order_item
end
