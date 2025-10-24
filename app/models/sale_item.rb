class SaleItem < ApplicationRecord
  belongs_to :nile_product
  before_save :calculate_total
  belongs_to :sale
  belongs_to :purchase_type

  after_create :create_stock_adjustment
  after_update :update_stock_adjustment
  def calculate_total
    self.total = quantity_sold * amount
  end

  def name
    return "#{nile_product.name}  #{sale.order_number}"
  end

  def create_stock_adjustment
    available_stock = StoreTransaction.available_stock_for(nile_product_id)
    if available_stock >= quantity_sold
      StoreTransaction.create!(
        nile_product_id: nile_product_id,
        territory_id: sale.territory_id,
        user_id: sale.user_id,
        store_id: sale.store_id,
        quantity: quantity_sold,
        direction: "out",
        movement_type: "sale",
        notes: "#{purchase_type.name}",
        transaction_date: sale.sale_date
      )
    end
  end

  def update_stock_adjustment
    available_stock = StoreTransaction.available_stock_for(nile_product_id)
    if available_stock >= quantity_sold
      transaction = StoreTransaction.find_by(
        nile_product_id: nile_product_id,
        territory_id: sale.territory_id,
        user_id: sale.user_id,
        store_id: sale.store_id,
        movement_type: "sale",
        transaction_date: sale.sale_date
      )
      if transaction
        transaction.update(
          quantity: quantity_sold,
          notes: "#{purchase_type.name}"
        )
      end
    end
  end
  
end
