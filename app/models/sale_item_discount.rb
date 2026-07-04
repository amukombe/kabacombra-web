class SaleItemDiscount < ApplicationRecord
  belongs_to :sale_item
  belongs_to :discount, optional: true
end
