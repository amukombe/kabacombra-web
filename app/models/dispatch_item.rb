class DispatchItem < ApplicationRecord
  belongs_to :order_item
  def name
    return "#{order_item.nile_product.name}"
  end
end
