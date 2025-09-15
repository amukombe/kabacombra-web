class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :territory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :bank_account, null: false, foreign_key: true
      t.references :recepient, polymorphic: true, null: false
      t.string :payment_method
      t.decimal :amount
      t.datetime :payment_date
      t.string :payment_ref

      t.timestamps
    end
  end
end
