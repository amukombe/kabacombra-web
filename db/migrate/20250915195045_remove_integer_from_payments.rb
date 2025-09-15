class RemoveIntegerFromPayments < ActiveRecord::Migration[7.2]
  def change
    remove_column :payments, :integer, :string
  end
end
