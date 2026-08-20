class MakeDestinationOptionalAndAddStoreToNileProducts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :nile_products, :destination_id, true

    add_reference :nile_products, :store, null: true, foreign_key: true
  end
end