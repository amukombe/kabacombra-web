class SaleItem < ApplicationRecord
  belongs_to :nile_product
  belongs_to :loading_order_item
  before_save :calculate_total
  belongs_to :sale
  belongs_to :purchase_type
  has_many :sale_item_discounts
  accepts_nested_attributes_for :sale_item_discounts, allow_destroy: true
  after_create :create_stock_adjustment
  after_update :update_stock_adjustment

  validates :quantity_ordered,  numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_sold, numericality: { greater_than_or_equal_to: 0 }
  validate :delivered_quantity_cannot_exceed_ordered_quantity

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
  def discount_amount
    sale_item_discounts.sum(:discount_value)
  end
  def quantity_delivered
    quantity_sold.to_d
  end

  def quantity_balance
    quantity_ordered.to_d - quantity_delivered
  end
  def delivered_quantity_cannot_exceed_ordered_quantity
    return if quantity_ordered.blank? || quantity_sold.blank?

    if quantity_sold.to_d > quantity_ordered.to_d
      errors.add(
        :quantity_sold,
        "cannot exceed the ordered quantity"
      )
    end
  end
end
