class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.date :order_date
      t.references :user, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: true
      t.decimal :total_price

      t.timestamps
    end
  end
end
