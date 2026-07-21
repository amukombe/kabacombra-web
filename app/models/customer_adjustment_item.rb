class CustomerAdjustmentItem < ApplicationRecord
  belongs_to :customer_adjustment
  belongs_to :sale_item, optional: true
  belongs_to :nile_product, optional: true

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  before_validation :copy_sale_item_details
  before_validation :calculate_total

  validate :sale_item_belongs_to_selected_sale
  validate :credit_quantity_cannot_exceed_sold_quantity

  private

  def copy_sale_item_details
    return if sale_item.blank?

    self.nile_product ||= sale_item.nile_product

    if unit_price.blank? || unit_price.to_d.zero?
      self.unit_price = sale_item.amount
    end
  end

  def calculate_total
    self.total_amount =
      quantity.to_d *
      unit_price.to_d -
      discount_amount.to_d +
      tax_amount.to_d
  end

  def sale_item_belongs_to_selected_sale
    return if sale_item.blank?
    return if customer_adjustment&.sale.blank?

    if sale_item.sale_id != customer_adjustment.sale_id
      errors.add(
        :sale_item,
        "does not belong to the selected sale"
      )
    end
  end

  def credit_quantity_cannot_exceed_sold_quantity
    return unless customer_adjustment&.credit_note?
    return if sale_item.blank?

    previously_credited = CustomerAdjustmentItem
                            .joins(:customer_adjustment)
                            .where(sale_item_id: sale_item_id)
                            .where(
                              customer_adjustments: {
                                adjustment_type: "credit_note",
                                status: "approved"
                              }
                            )
                            .where.not(id: id)
                            .sum(:quantity)

    available_quantity =
      sale_item.quantity_sold.to_d -
      previously_credited.to_d

    if quantity.to_d > available_quantity
      errors.add(
        :quantity,
        "cannot exceed #{available_quantity}"
      )
    end
  end
end