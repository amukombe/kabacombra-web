class RenameEmptyPrcieToNileProduct < ActiveRecord::Migration[7.2]
  def change
    rename_column :nile_products, :epmty_price, :empty_price
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
