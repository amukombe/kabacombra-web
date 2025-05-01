class StockTransferItem < ApplicationRecord
  belongs_to :nile_product
  belongs_to :stock_transfer
end
