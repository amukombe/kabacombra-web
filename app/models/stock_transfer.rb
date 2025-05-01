class StockTransfer < ApplicationRecord
    belongs_to :territory
    has_many :stock_transfer_items, dependent: :destroy
    accepts_nested_attributes_for :stock_transfer_items, allow_destroy: true
    enum transfer_type: { warehouse_transfer: "warehouse_transfer",branch_transfer: "branch_transfer", distributor_transfer: "distributor_transfer"}
    after_create :create_inventory_transactions

    private
    def create_inventory_transactions
        if(self.transfer_type=="warehouse_transfer")
            stock_transfer_items.each do |item|
            quantity = item.transfer_quantity
            transaction_type = item.stock_transfer.transfer_type
            next unless quantity.present? && quantity > 0
                # deduct from where it's coming from
                InventoryTransaction.create!(
                    nile_product_id: item.nile_product_id,
                    territory_id: self.territory_id,
                    transaction_quantity: quantity,
                    transaction_type: 'warehouse transfer out',
                    direction: 'out',
                    transaction_date: self.transfer_date
                )
                # transfer to another warehouse
                InventoryTransaction.create!(
                    nile_product_id: item.nile_product_id,
                    territory_id: self.territory_id,
                    transaction_quantity: quantity,
                    transaction_type: 'warehouse transfer in',
                    direction: 'in',
                    transaction_date: self.transfer_date
                )
            end
        elsif self.transfer_type=="branch_transfer"
            stock_transfer_items.each do |item|
                quantity = item.transfer_quantity
                transaction_type = item.stock_transfer.transfer_type
                next unless quantity.present? && quantity > 0
                # deduct from where house to another
                InventoryTransaction.create!(
                    nile_product_id: item.nile_product_id,
                    territory_id: self.source_id,
                    transaction_quantity: quantity,
                    transaction_type: 'branch transfer out',
                    direction: 'out',
                    transaction_date: self.transfer_date
                )
                # transfer to another
                InventoryTransaction.create!(
                    nile_product_id: item.nile_product_id,
                    territory_id: self.destination_id,
                    transaction_quantity: quantity,
                    transaction_type: 'branch transfer in',
                    direction: 'in',
                    transaction_date: self.transfer_date
                )
            end
        elsif self.transfer_type=="distributor_transfer"
            stock_transfer_items.each do |item|
                quantity = item.transfer_quantity
                transaction_type = item.stock_transfer.transfer_type
                next unless quantity.present? && quantity > 0
                # deduct from where house to another
                InventoryTransaction.create!(
                    nile_product_id: item.nile_product_id,
                    territory_id: self.territory_id,
                    transaction_quantity: quantity,
                    transaction_type: 'distributor_transfer',
                    direction: 'in',
                    transaction_date: self.transfer_date
                )
            end
        end
      end
end
