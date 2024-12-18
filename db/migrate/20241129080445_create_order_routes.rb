class CreateOrderRoutes < ActiveRecord::Migration[7.2]
  def change
    create_table :order_routes do |t|
      t.references :order, null: false, foreign_key: true
      t.references :route, null: false, foreign_key: true

      t.timestamps
    end
  end
end
