class LoadingOrderItem < ApplicationRecord
  belongs_to :loading_order
  belongs_to :nile_product

  has_many :sale_items

  after_create :create_transaction
  before_create :set_remaining_quantity

  validates :remaining_quantity,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validate :quantity_loaded_cannot_exceed_available_stock

  def name
    nile_product.name
  end

  def self.search_quantity_out(params, territory_id, product_id)
    start_date =
      params[:start_date].present? ?
        Date.parse(params[:start_date]).beginning_of_day :
        Date.current.beginning_of_day

    end_date =
      params[:end_date].present? ?
        Date.parse(params[:end_date]).end_of_day :
        Date.current.end_of_day

    query = joins(:loading_order)
      .where(
        nile_product_id: product_id,
        loading_orders: {
          territory_id: territory_id
        }
      )
      .where(
        "loading_orders.loading_date >= ? AND loading_orders.loading_date <= ?",
        start_date,
        end_date
      )

    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.where(
        "loading_orders.order_number LIKE ?",
        search
      )
    end

    query.order("loading_orders.loading_date DESC")
  end

  private

  def set_remaining_quantity
    self.remaining_quantity = quantity_loaded
  end

  def quantity_loaded_cannot_exceed_available_stock
    return if nile_product_id.blank?
    return if quantity_loaded.blank?
    return if loading_order.blank?
    return if loading_order.territory_id.blank?

    available_stock = InventoryTransaction.available_quantity(
      product_id: nile_product_id,
      territory_id: loading_order.territory_id
    )

    if quantity_loaded > available_stock
      errors.add(
        :quantity_loaded,
        "cannot be greater than available stock (#{available_stock})"
      )
    end
  end

  def create_transaction
    StoreTransaction.create!(
      nile_product_id: nile_product_id,
      territory_id: loading_order.territory_id,
      user_id: loading_order.user_id,
      store_id: loading_order.store_id,
      quantity: quantity_loaded,
      direction: "in",
      movement_type: "loading order",
      notes: "from loading order",
      transaction_date: loading_order.loading_date
    )
  end
end