class CreateVendorPayments < ActiveRecord::Migration[7.2]
  def change
    create_table :vendor_payments do |t|
      t.references :territory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :payment_date
      t.string :journal_no
      t.string :ref_no
      t.decimal :payments
      t.decimal :suspence

      t.timestamps
    end
  end
end
