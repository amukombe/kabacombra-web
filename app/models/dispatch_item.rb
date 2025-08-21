class DispatchItem < ApplicationRecord
  belongs_to :order_item
  has_many :inventory_items, dependent: :destroy
  def name
    return "#{order_item.nile_product.name}"
  end
end
