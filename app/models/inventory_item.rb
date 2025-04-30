class InventoryItem < ApplicationRecord
  scope :oldest, -> { order(created_at: :asc) }
  belongs_to :inventory
  belongs_to :nile_product
  belongs_to :dispatch_item, optional: true
  has_many :inventory_item_stores
  has_many :store, through: :inventory_item_store
  has_many :inventory_transactions, dependent: :destroy
  
  
  before_save :initialize_quantity_sold
  before_validation :generate_stock_number, on: :create
  after_create :create_transactions

  
  def self.search(params, territory_id)
    query = joins(:inventory_transactions, :inventory, :nile_product)
      .where("inventories.territory_id = ?", territory_id)

    if params[:query].present?
      query = query.where("nile_products.name LIKE ?", "%#{sanitize_sql_like(params[:query])}%")
    end

    query.group('nile_products.id, nile_products.name,inventory_items.selling_price')
        .select(
          'nile_products.id  AS nile_product_id, nile_products.name, inventory_items.selling_price',
          'SUM(CASE WHEN inventory_transactions.direction = "in" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_opening_stock',
          'SUM(CASE WHEN inventory_transactions.direction = "in" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_in',
          'SUM(CASE WHEN inventory_transactions.direction = "out" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_out'
        )
        #select("nile_product_id, nile_products.name, SUM(quantity_received-quantity_sold) as openning_stock, SUM(quantity_received) as total_purchases, SUM(quantity_sold) as total_quantity_sold, SUM(breakages) as total_breakages, SUM(returns) as total_returns, SUM(nbl_return) as total_nbl_returns, SUM(transfers) as total_transfers, SUM(remaining_quantity*nile_products.selling_price) as total_closing_stock_value")
  end

  def self.search_stock(params, territory_id, product_id)
    query = joins(inventory: {}, nile_product:{})
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

  def create_transactions
    return unless inventory.persisted?
  
    inventory_transactions.create!(
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: quantity_received,
      transaction_type: 'opening_stock',
      direction: 'in',
      transaction_date: inventory.delivery_time
    ) if quantity_received.present? && quantity_received > 0
  
    inventory_transactions.create!(
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: breakages,
      transaction_type: 'breakage',
      direction: 'out',
      transaction_date: inventory.delivery_time
    ) if breakages.present? && breakages > 0
  
    inventory_transactions.create!(
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: missing_bottles,
      transaction_type: 'missing bottles',
      direction: 'out',
      transaction_date: inventory.delivery_time
    ) if missing_bottles.present? && missing_bottles > 0

    inventory_transactions.create!(
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: complaints,
      transaction_type: 'complaint',
      direction: 'out',
      transaction_date: inventory.delivery_time
    ) if complaints.present? && complaints > 0

    inventory_transactions.create!(
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: bad_beer,
      transaction_type: 'bad beer',
      direction: 'out',
      transaction_date: inventory.delivery_time
    ) if bad_beer.present? && bad_beer > 0

    inventory_transactions.create!(
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: good_beer,
      transaction_type: 'good beer',
      direction: 'in',
      transaction_date: inventory.delivery_time
    ) if good_beer.present? && good_beer > 0

    inventory_transactions.create!(
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: transfers,
      transaction_type: 'transfers',
      direction: 'out',
      transaction_date: inventory.delivery_time
    ) if transfers.present? && transfers > 0

    inventory_transactions.create!(
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: returns,
      transaction_type: 'returns',
      direction: 'in',
      transaction_date: inventory.delivery_time
    ) if returns.present? && returns > 0

    inventory_transactions.create!(
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: nbl_return,
      transaction_type: 'nbl_return',
      direction: 'out',
      transaction_date: inventory.delivery_time
    ) if nbl_return.present? && nbl_return > 0
  end
end
