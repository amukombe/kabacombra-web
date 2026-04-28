class AddEmptyNumberToEmptyTypes < ActiveRecord::Migration[7.2]
  def change
    add_column :empty_types, :empty_number, :integer
  end
end
