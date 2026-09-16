class CreateCustomerPaymentAllocations < ActiveRecord::Migration[7.2]
  def change
    create_table :customer_payment_allocations do |t|
      t.references :customer_payment, null: false, foreign_key: true
      t.references :sale, null: false, foreign_key: true
      t.decimal :amount
      t.datetime :allocated_at

      t.timestamps
    end
    add_index :customer_payment_allocations,
              [:customer_payment_id, :sale_id],
              unique: true,
              name: "index_customer_payment_allocations_unique"
  end
end
