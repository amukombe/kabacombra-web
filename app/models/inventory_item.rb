class InventoryItem < ApplicationRecord
  scope :oldest, -> { order(created_at: :asc) }
  belongs_to :inventory
  belongs_to :dispatch_item
  before_save :initialize_quantity_sold
  before_validation :generate_stock_number, on: :create
  #validate :validate_quantity
  has_many :inventory_item_stores
  has_many :store, through: :inventory_item_store
  def self.search(params, territory_id)
    query = InventoryItem
      .joins(inventory: {}, dispatch_item: { order_item: :nile_product })
      .where("inventories.territory_id = ?", territory_id)

    if params[:query].present?
      query = query.where("nile_products.name LIKE ?", "%#{sanitize_sql_like(params[:query])}%")
    end

    query.group(:nile_product_id)
        .select("nile_product_id, nile_products.name, SUM(remaining_quantity) as openning_stock, SUM(quantity) as total_purchases, SUM(quantity_sold) as total_quantity_sold, SUM(breakages) as total_breakages, SUM(returns) as total_returns, SUM(nbl_return) as total_nbl_returns, SUM(transfers) as total_transfers")
  end

  def self.search_stock(params, territory_id, product_id)
    query = joins(inventory: {}, dispatch_item: { order_item: :nile_product })
    .where("inventories.territory_id = ? AND nile_products.id=?", territory_id, product_id)

    if params[:query].present?
      query = query.where("nile_products.name LIKE ? AND nile_products.id=?", "%#{sanitize_sql_like(params[:query])}%", product_id)
    end
    query
  end

  def quantity
    return (self.quantity_received - self.quantity_sold)
  end

  private
  def generate_stock_number
    if self.stock_no.blank?
      last_stock = InventoryItem.order(:created_at).last
      next_number = last_stock&.stock_no.to_i + 1 || 1
      self.stock_no = next_number.to_s.rjust(5, '0')
    end
  end

  def validate_quantity
      total_qty = self.quantity_received + self.breakages + self.missing_bottles
      if total_qty != self.quantity_dispatched
        errors.add(:quantity_dispatched, "must be equal to received + breakages + missing bottles")
      end
  end
  

  def initialize_quantity_sold
    self.quantity_sold ||= 0
  end
end
