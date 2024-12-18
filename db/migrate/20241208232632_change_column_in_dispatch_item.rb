class ChangeColumnInDispatchItem < ActiveRecord::Migration[7.2]
  def change
    remove_column :dispatch_items, :beer_dispatch
    add_reference :dispatch_items, :beer_dispatch, null: false, foreign_key: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
