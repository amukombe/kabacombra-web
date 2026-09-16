class CreateCustomerPayments < ActiveRecord::Migration[7.2]
  def change
    create_table :customer_payments do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :payment_no
      t.datetime :payment_date
      t.integer :payment_method
      t.decimal :amount
      t.string :payment_ref
      t.decimal :allocated_amount
      t.decimal :credit_amount
      t.text :notes

      t.timestamps
    end
    add_index :customer_payments,
              :payment_no,
              unique: true
  end
end
