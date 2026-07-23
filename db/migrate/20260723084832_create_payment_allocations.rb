class CreatePaymentAllocations < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_allocations do |t|
      t.references :sale_payment,
                   null: false,
                   foreign_key: true

      t.references :sale,
                   null: false,
                   foreign_key: true

      t.decimal :amount,
                precision: 15,
                scale: 2,
                null: false,
                default: 0

      t.datetime :allocated_at,
                 null: false

      t.timestamps
    end

    add_index :payment_allocations,
              [:sale_payment_id, :sale_id],
              name: "index_payment_allocations_on_payment_and_sale"
  end
end