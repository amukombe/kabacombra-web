class InventoryTransaction < ApplicationRecord
  belongs_to :territory
  belongs_to :nile_product

  #this is for daily statement
  scope :before_date, ->(date) { where("DATE(transaction_date) < ?", date) }
  scope :on_date, ->(date) { where("DATE(transaction_date)=?", date) }
  
  def self.daily_statement(date)
    product_ids = InventoryTransaction.where("DATE(transaction_date) <= ?", date).distinct.pluck(:nile_product_id)

    product_ids.map do |product_id|
      product = NileProduct.find(product_id)

      opening_stock = before_date(date).where(nile_product_id: product_id).sum(
        "CASE WHEN direction = 'in' THEN transaction_quantity
              WHEN direction = 'out' THEN -transaction_quantity
              ELSE 0 END"
      )

      purchases = on_date(date).where(nile_product_id: product_id, direction: "in").sum(:transaction_quantity)
      sales     = on_date(date).where(nile_product_id: product_id, direction: "out").sum(:transaction_quantity)

      closing_stock = opening_stock + purchases - sales

      DailyInventoryStatement.new(
        product_id: product_id,
        product: product,
        opening_stock: opening_stock,
        purchases: purchases,
        sales: sales,
        closing_stock: closing_stock
      )
    end
  end

  #end of daily statement

  def self.search(params, territory_id)
    query = joins(:territory, :nile_product)
      .where("territory_id = ?", territory_id)

    if params[:query].present?
      query = query.where("nile_products.name LIKE ?", "%#{sanitize_sql_like(params[:query])}%")
    end

    query.group('nile_products.id, nile_products.name,nile_products.selling_price')
        .select(
          'nile_products.id  AS nile_product_id, nile_products.name, nile_products.selling_price',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "purchase" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_opening_stock',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "purchase breakage" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_purchase_breakage',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "warehouse breakage" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_warehouse_breakage',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "within store breakage" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_within_store_breakage',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "store to store breakage" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_store_to_store_breakage',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "missing bottles" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_missing_bottles',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "complaint" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_complaint',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "bad beer" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_bad_beer',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "good beer" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_good_beer',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "branch transfer out" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_branch_transfer_out',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "branch transfer in" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_branch_transfer_in',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "returns" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_returns',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "nbl_return" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_nbl_return',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "distribution" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_distribution',
          'SUM(CASE WHEN inventory_transactions.transaction_type = "distributor_transfer" THEN inventory_transactions.transaction_quantity ELSE 0 END) AS total_distributor_transfer'
        )
  end

  def self.search_openning_stock(params, territory_id, product_id)
    query = joins(:territory, :nile_product)
    .where("territory_id = ? AND nile_products.id=? AND direction=?", territory_id, product_id, "in")

    if params[:query].present?
      query = joins(:territory, :nile_product)
      .where("territory_id = ? AND nile_products.id=? AND direction=?", territory_id, product_id, "in")
    end
    query
  end

  def self.search_quantity_in(params, territory_id, product_id)
    query = joins(:territory, :nile_product)
    .where("territory_id = ? AND nile_products.id=? AND direction=?", territory_id, product_id, "in")

    if params[:query].present?
      query = joins(:territory, :nile_product)
      .where("territory_id = ? AND nile_products.id=? AND direction=?", territory_id, product_id, "in")
    end
    query
  end

  def self.search_quantity_out(params, territory_id, product_id)
    query = joins(:territory, :nile_product)
    .where("territory_id = ? AND nile_products.id=? AND direction=?", territory_id, product_id, "out")

    if params[:query].present?
      query = joins(:territory, :nile_product)
      .where("territory_id = ? AND nile_products.id=? AND direction=?", territory_id, product_id, "out")
    end
    query
  end

  # available quantity
  def self.available_quantity(product_id:, territory_id:)
    where(nile_product_id: product_id, territory_id: territory_id)
      .pluck(
        Arel.sql("
          SUM(CASE WHEN direction = 'in' THEN transaction_quantity ELSE 0 END) -
          SUM(CASE WHEN direction = 'out' THEN transaction_quantity ELSE 0 END)
        ")
      ).first.to_i
  end
end
