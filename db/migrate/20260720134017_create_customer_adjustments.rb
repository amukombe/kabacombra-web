class CreateCustomerAdjustments < ActiveRecord::Migration[7.2]
  def change
    create_table :customer_adjustments do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.string :adjustment_number, null: false
      t.string :adjustment_type, null: false
      t.date :adjustment_date, null: false
      t.text :reason
      t.string :status, null: false, default: "draft"
      t.decimal :subtotal
      t.decimal :discount_total
      t.decimal :tax_total
      t.decimal :total_amount
      t.decimal :applied_amount
      t.bigint :created_by_id
      t.bigint :approved_by_id
      t.datetime :approved_at

      t.timestamps
    end
  end
end
