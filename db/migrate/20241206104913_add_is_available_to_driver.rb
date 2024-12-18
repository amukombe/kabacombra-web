class AddIsAvailableToDriver < ActiveRecord::Migration[7.2]
  def change
    add_column :drivers, :is_available, :boolean
  end
end
