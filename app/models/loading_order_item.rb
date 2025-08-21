class LoadingOrderItem < ApplicationRecord
  belongs_to :loading_order
  belongs_to :nile_product
  has_many :sale_items
  has_many :store_transactions, dependent: :destroy

  def name
    return "#{nile_product.name}"
  end

  def create_transaction
    store_transaction.create!(
      
    )
  end
end
