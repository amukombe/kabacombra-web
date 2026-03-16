class DispatchItem < ApplicationRecord
  belongs_to :order_item
  has_many :inventory_items, dependent: :destroy
  
  def name
    return "#{order_item.nile_product.name}"
  end

  def total_price
    return quantity_dispatched.to_i * order_item.unit_price.to_i
  end
  
end
