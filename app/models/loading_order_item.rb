class LoadingOrderItem < ApplicationRecord
  belongs_to :loading_order
  belongs_to :nile_product

  has_many :sale_items

  after_create :create_transaction
  before_create :set_remaining_quantity

  validates :remaining_quantity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def name
    nile_product.name
  end

  private

  def set_remaining_quantity
    self.remaining_quantity = quantity_loaded
  end

  def create_transaction
    StoreTransaction.create!(
      nile_product_id: nile_product_id,
      territory_id: loading_order.territory_id,
      user_id: loading_order.user_id,
      store_id: loading_order.store_id,
      quantity: quantity_loaded,
      direction: "in",
      movement_type: "loading order",
      notes: "from loading order",
      transaction_date: loading_order.loading_date
    )
  end
end