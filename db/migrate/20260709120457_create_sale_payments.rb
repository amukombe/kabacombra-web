class CreateSalePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :sale_payments do |t|
      t.references :sale, null: false, foreign_key: true
      t.string :invoice_reference
      t.string :receipt_number
      t.decimal :amount
      t.date :payment_date
      t.integer :mode_of_payment
      t.decimal :balance_before
      t.decimal :balance_after
      t.text :notes

      t.timestamps
    end
    add_index :sale_payments, :receipt_number, unique: true
  end
end
