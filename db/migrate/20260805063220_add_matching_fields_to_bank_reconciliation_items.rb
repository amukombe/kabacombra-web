class AddMatchingFieldsToBankReconciliationItems < ActiveRecord::Migration[7.2]
  def change

    add_reference :bank_reconciliation_items,
                  :matched_transaction,
                  foreign_key: {
                    to_table: :bank_transactions
                  }

    add_column :bank_reconciliation_items,
               :matched_at,
               :datetime

  end
end