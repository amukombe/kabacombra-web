class SaleItem < ApplicationRecord
  belongs_to :loading_order_item
  before_save :calculate_total
  belongs_to :sale
  belongs_to :purchase_type
  def calculate_total
    self.total = quantity_sold * amount
  end

  def name
    return "#{loading_order_item.nile_product.name}  #{loading_order_item.loading_order.order_number}"
  end
  
end
