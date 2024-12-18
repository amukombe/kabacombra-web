class CreateOrderDrivers < ActiveRecord::Migration[7.2]
  def change
    create_table :order_drivers do |t|
      t.references :order, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true

      t.timestamps
    end
  end
end
