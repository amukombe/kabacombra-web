class CreateCreditMemoAllocations < ActiveRecord::Migration[7.2]
  def change
    create_table :credit_memo_allocations do |t|
      t.references :customer_credit_memo,
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

    add_index :credit_memo_allocations,
              [:customer_credit_memo_id, :sale_id],
              name: "index_credit_memo_allocations_on_memo_and_sale"
  end
end