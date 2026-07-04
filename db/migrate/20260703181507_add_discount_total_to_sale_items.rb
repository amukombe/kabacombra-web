class AddDiscountTotalToSaleItems < ActiveRecord::Migration[7.2]
  def change
    add_column :sale_items, :discount_total, :decimal
  end
end
