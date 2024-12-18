class RenameDistnceToDistanceInRoutes < ActiveRecord::Migration[7.2]
  def change
    rename_column :routes, :distatnce, :distance
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
