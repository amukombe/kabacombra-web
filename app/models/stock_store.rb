class StockStore < ApplicationRecord
  belongs_to :inventory_item
  belongs_to :store
end
