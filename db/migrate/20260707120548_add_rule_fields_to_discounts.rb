class AddRuleFieldsToDiscounts < ActiveRecord::Migration[7.2]
  def change
    add_column :discounts, :rule_type, :string, default: "simple"
    add_column :discounts, :buy_quantity, :decimal
    add_column :discounts, :discount_quantity, :decimal
    add_column :discounts, :repeatable, :boolean, default: false
  end
end
