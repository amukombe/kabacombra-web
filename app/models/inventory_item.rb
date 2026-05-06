class InventoryItem < ApplicationRecord
  scope :oldest, -> { order(created_at: :asc) }

  belongs_to :inventory
  belongs_to :nile_product
  belongs_to :dispatch_item, optional: true

  has_many :inventory_item_stores, dependent: :destroy
  has_many :stores, through: :inventory_item_stores
  # has_many :inventory_transactions, dependent: :destroy

  before_save :initialize_quantity_sold
  before_validation :generate_stock_number, on: :create
  after_create :create_transactions
  before_destroy :remove_transactions

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
        .order("nile_products.product_number ASC")
        #select("nile_product_id, nile_products.name, SUM(quantity_received-quantity_sold) as openning_stock, SUM(quantity_received) as total_purchases, SUM(quantity_sold) as total_quantity_sold, SUM(breakages) as total_breakages, SUM(returns) as total_returns, SUM(nbl_return) as total_nbl_returns, SUM(transfers) as total_transfers, SUM(remaining_quantity*nile_products.selling_price) as total_closing_stock_value")
  end

  def self.product_summary(params, territory_id)
    query = NileProduct
      .left_joins(inventory_items: :inventory)
      .where("inventories.territory_id = ? OR inventories.id IS NULL", territory_id)

    if params[:query].present?
      query = query.where("nile_products.name LIKE ?", "%#{sanitize_sql_like(params[:query])}%")
    end

    query.group("nile_products.id, nile_products.name")
        .select(
          "nile_products.name AS product_name",

          "SUM(CASE WHEN inventories.status_id = 13 
            THEN COALESCE(inventory_items.quantity_received, 0) 
            ELSE 0 END) AS total_received",

          "SUM(CASE WHEN inventories.status_id = 13 
            THEN COALESCE(inventory_items.breakages, 0) 
            ELSE 0 END) AS total_breakages",

          "SUM(CASE WHEN inventories.status_id = 13 
            THEN COALESCE(inventory_items.complaints, 0) 
            ELSE 0 END) AS total_complaints",

          "SUM(CASE WHEN inventories.status_id = 13 
            THEN 
              COALESCE(inventory_items.quantity_received, 0) +
              COALESCE(inventory_items.breakages, 0) +
              COALESCE(inventory_items.complaints, 0)
            ELSE 0 END) AS total_quantity"
        )
        .order("nile_products.product_number ASC")
  end

  def self.search_stock(params, territory_id, product_id)
    query = joins(inventory: {}, nile_product: {})
      .where("inventories.territory_id = ? AND nile_products.id=?", territory_id, product_id)

    if params[:query].present?
      query = query.where("nile_products.name LIKE ? AND nile_products.id=?", "%#{sanitize_sql_like(params[:query])}%", product_id)
    end

    query
  end

  def quantity
    quantity_received - quantity_sold
  end

  def total
    total_quantity * purchase_price
  end

  def total_quantity
    quantity_received.to_i + breakages.to_i + complaints.to_i
  end

  def total_case
    total_quantity * nile_product.empty_type.price
  end

  def total_Purchase
    total + total_case
  end

  private

  def generate_stock_number
    if stock_no.blank?
      last_stock = InventoryItem.order(:created_at).last
      next_number = last_stock&.stock_no.to_i + 1 || 1
      self.stock_no = next_number.to_s.rjust(5, '0')
    end
  end

  def validate_quantity
    total_qty = quantity_received + breakages + missing_bottles
    if total_qty != quantity_dispatched
      errors.add(:quantity_dispatched, "must be equal to received + breakages + missing bottles")
    end
  end

  def initialize_quantity_sold
    self.quantity_sold ||= 0
  end

  def create_transactions
    return unless inventory.persisted?

    transaction_definitions.each do |attributes|
      InventoryTransaction.create!(attributes)
    end
  end

  def remove_transactions
    InventoryTransaction.where("note LIKE ?", "#{transaction_note_prefix}%").delete_all

    transaction_definitions.each do |attributes|
      legacy_transaction_id = InventoryTransaction.where(
        nile_product_id: attributes[:nile_product_id],
        territory_id: attributes[:territory_id],
        transaction_quantity: attributes[:transaction_quantity],
        transaction_type: attributes[:transaction_type],
        direction: attributes[:direction],
        transaction_date: attributes[:transaction_date],
        note: [nil, ""]
      ).order(created_at: :desc).limit(1).pick(:id)

      InventoryTransaction.where(id: legacy_transaction_id).delete_all if legacy_transaction_id.present?
    end
  end

  def transaction_definitions
    [
      build_transaction(quantity_received, 'purchase', 'in'),
      #build_transaction(breakages, 'purchase breakage', 'out'),
      #build_transaction(missing_bottles, 'missing bottles', 'out'),
      #build_transaction(complaints, 'complaint', 'out'),
      build_transaction(bad_beer, 'bad beer', 'out'),
      build_transaction(good_beer, 'good beer', 'in'),
      build_transaction(transfers, 'transfers', 'out'),
      build_transaction(returns, 'returns', 'in'),
      build_transaction(nbl_return, 'nbl_return', 'out')
    ].compact
  end

  def build_transaction(quantity, transaction_type, direction)
    return if quantity.blank? || quantity.to_d <= 0

    {
      nile_product_id: nile_product_id,
      territory_id: inventory.territory_id,
      transaction_quantity: quantity,
      transaction_type: transaction_type,
      direction: direction,
      transaction_date: inventory.delivery_time,
      note: transaction_note(transaction_type, direction)
    }
  end

  def transaction_note_prefix
    "inventory_item:#{id}:"
  end

  def transaction_note(transaction_type, direction)
    "#{transaction_note_prefix}#{transaction_type}:#{direction}"
  end
end

