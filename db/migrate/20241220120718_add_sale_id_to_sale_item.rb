class AddSaleIdToSaleItem < ActiveRecord::Migration[7.2]
  def change
    add_reference :sale_items, :sale, null: false, foreign_key: true
  end
end
