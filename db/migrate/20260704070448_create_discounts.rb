class CreateDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.string :discount_type
      t.decimal :discount_value
      t.boolean :active

      t.timestamps
    end
  end
end
