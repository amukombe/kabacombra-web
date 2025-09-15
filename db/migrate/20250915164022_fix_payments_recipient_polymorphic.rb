class FixPaymentsRecipientPolymorphic < ActiveRecord::Migration[7.2]
  def change
    # remove wrong columns
    remove_column :payments, :recepient_type, :integer
    remove_column :payments, :recepient_id, :bigint

    # add correct ones
    add_column :payments, :recipient_type, :string, null: false
    add_column :payments, :recipient_id, :bigint, null: false

    add_index :payments, [:recipient_type, :recipient_id]
  end
end
