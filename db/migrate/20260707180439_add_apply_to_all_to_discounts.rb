class AddApplyToAllToDiscounts < ActiveRecord::Migration[7.2]
  def change
    add_column :discounts, :apply_to_all, :boolean
  end
end
