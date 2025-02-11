class CreatePurchaseTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :purchase_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
