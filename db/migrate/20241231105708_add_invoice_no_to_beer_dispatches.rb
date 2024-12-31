class AddInvoiceNoToBeerDispatches < ActiveRecord::Migration[7.2]
  def change
    add_column :beer_dispatches, :invoice_no, :string
  end
end
