class AddItemsToDispatchItems < ActiveRecord::Migration[7.2]
  def change
    add_column :dispatch_items, :fdn, :string
    add_column :dispatch_items, :invoice_no, :string
  end
end
