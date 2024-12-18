class LoadingOrderItem < ApplicationRecord
  belongs_to :loading_order
  belongs_to :nile_product
  
end
