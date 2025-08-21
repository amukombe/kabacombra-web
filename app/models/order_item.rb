class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :nile_product
  before_save :calculate_total
  has_one :dispatch_item, dependent: :destroy
  
  def name
    return "#{nile_product.name}"
  end
  private

  def calculate_total
    self.total = quantity * unit_price
  end
end
