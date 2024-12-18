class CreateLoadingOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :loading_orders do |t|
      t.references :driver, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.string :vehicle_numperplate
      t.string :destination
      t.datetime :loading_date
      t.string :order_number
      t.integer :sales_man
      t.integer :authorized_by
      t.integer :verified_by

      t.timestamps
    end
  end
end
