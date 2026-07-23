class CreateCustomerCreditMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :customer_credit_memos do |t|
      t.references :customer,
                   null: false,
                   foreign_key: true

      t.string :memo_number,
               null: false

      t.date :memo_date,
             null: false

      t.decimal :amount,
                precision: 15,
                scale: 2,
                null: false,
                default: 0

      t.string :memo_type,
               null: false,
               default: "appreciation"

      t.text :reason

      t.string :status,
               null: false,
               default: "draft"

      t.bigint :created_by_id,
               null: false

      t.bigint :approved_by_id

      t.datetime :approved_at

      t.timestamps
    end

    add_index :customer_credit_memos,
              :memo_number,
              unique: true

    add_index :customer_credit_memos,
              [:customer_id, :status]

    add_foreign_key :customer_credit_memos,
                    :users,
                    column: :created_by_id

    add_foreign_key :customer_credit_memos,
                    :users,
                    column: :approved_by_id
  end
end