class StoreTransaction < ApplicationRecord
  belongs_to :nile_product
  belongs_to :territory
  belongs_to :user
  #belongs_to :loading_order_item

  def available_stock
    stock_transactions = StoreTransaction.where(nile_product_id: nile_product_id)
    total_in = stock_transactions.where(direction: 'in').sum(:quantity)
    total_out = stock_transactions.where(direction: 'out').sum(:quantity)
    
    return total_in - total_out
  end

  def self.available_stock_for(nile_product_id)
    stock_transactions = StoreTransaction.where(nile_product_id: nile_product_id)
    total_in  = stock_transactions.where(direction: 'in').sum(:quantity)
    total_out = stock_transactions.where(direction: 'out').sum(:quantity)
    total_in - total_out
  end
end
