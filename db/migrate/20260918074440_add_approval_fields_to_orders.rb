class AddApprovalFieldsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :orders, :approved_by, foreign_key: { to_table: :users }, null: true
    add_column :orders, :approved_at, :datetime, null: true
  end
end
