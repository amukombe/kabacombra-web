class AddRemainingQuantityToLoadingOrderItems < ActiveRecord::Migration[7.2]
  def change
    add_column :loading_order_items, :remaining_quantity, :decimal
  end
end
