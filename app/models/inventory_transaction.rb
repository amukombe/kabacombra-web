class InventoryTransaction < ApplicationRecord
  belongs_to :territory
  belongs_to :nile_product
  # belongs_to :inventory_item, optional: true
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

  def self.opening_stock(nile_product_id, territory_id, date)
    where(nile_product_id: nile_product_id, territory_id: territory_id)
      .where("DATE(transaction_date) < ?", date)
      .sum("CASE WHEN direction = 'in' THEN transaction_quantity ELSE -transaction_quantity END")
  end

end
