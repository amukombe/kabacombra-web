class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :financial_transaction, null: false, foreign_key: true
      t.references :payment_type, null: false, foreign_key: true
      t.string :recipient_type
      t.integer :recepient_id
      t.decimal :amount
      t.date :payment_date

      t.timestamps
    end
  end
end
