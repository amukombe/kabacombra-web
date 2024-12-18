class AddDriverToLoadingOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :loading_orders, :driver_name, :string
  end
end
