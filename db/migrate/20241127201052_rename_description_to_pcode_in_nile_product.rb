class RenameDescriptionToPcodeInNileProduct < ActiveRecord::Migration[7.2]
  def change
    rename_column :nile_products, :description, :pcode
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
