class InventoryItem < ApplicationRecord
  scope :oldest, -> { order(created_at: :asc) }
  belongs_to :inventory
  belongs_to :dispatch_item
  before_save :initialize_quantity_sold
  before_validation :generate_stock_number, on: :create
  validate :validate_quantity
  has_many :inventory_item_stores
  has_many :store, through: :inventory_item_store
  def self.search(params, territory_id)
    #params[:query].blank? ? all : where("dispatch_items.order_items.nile_products.name LIKE?", "%#{sanitize_sql_like(params[:query])}%")
    if params[:query].present?
      joins(:inventory, dispatch_item: { order_item: :nile_product })
        .where("nile_products.name LIKE ? AND inventories.territory_id=?", "%#{sanitize_sql_like(params[:query])}%",territory_id)
    else
      joins(:inventory).where("inventories.territory_id=?", territory_id)
    end
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
      total_qty = self.quantity_received + self.breakages
      if total_qty != self.quantity_dispatched
        errors.add(:quantity_dispatched, "must be equal to received + breakages")
      end
  end
  

  def initialize_quantity_sold
    self.quantity_sold ||= 0
  end
end
