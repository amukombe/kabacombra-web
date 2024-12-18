class AddIsSuperToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :is_super, :boolean
  end
end
