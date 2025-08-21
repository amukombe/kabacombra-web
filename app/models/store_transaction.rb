class StoreTransaction < ApplicationRecord
  belongs_to :nile_product
  belongs_to :territory
  belongs_to :user
end
