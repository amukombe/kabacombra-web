class AddReferenceTtCategoryToTtProduct < ActiveRecord::Migration[7.2]
  def change
    remove_reference :tt_products, :category, null: false, foreign_key: true
    add_reference :tt_products, :tt_category, null: false, foreign_key: true
  end
end
