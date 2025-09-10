class AddUpdatePayments < ActiveRecord::Migration[7.2]
  def change
    remove_column :payments, :recipient_type, :string
    add_reference :payments, :recipient, polymorphic: true, null: false
    add_reference :payments, :expense_category, foreign_key: true, null: true
    add_column :payments, :cheque_number, :string, null: true
    add_column :payments, :description, :text, null: true
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
