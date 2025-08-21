# app/models/daily_inventory_statement.rb
class DailyInventoryStatement
  attr_reader :product_id, :product, :opening_stock, :purchases, :sales, :closing_stock

  def initialize(product_id:, product:, opening_stock:, purchases:, sales:, closing_stock:)
    @product_id = product_id
    @product = product
    @opening_stock = opening_stock
    @purchases = purchases
    @sales = sales
    @closing_stock = closing_stock
  end
end