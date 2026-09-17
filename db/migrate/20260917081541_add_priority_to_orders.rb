class AddPriorityToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :priority, :boolean,default: false, null: false
  end
end
