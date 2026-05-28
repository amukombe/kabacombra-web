class StockTransfer < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :territory
    belongs_to :source, class_name: "Store", foreign_key: "source_id", optional: true
    belongs_to :destination, class_name: "Store", foreign_key: "destination_id", optional: true
    has_many :stock_transfer_items, dependent: :destroy
    accepts_nested_attributes_for :stock_transfer_items, allow_destroy: true
    enum transfer_type: { warehouse_transfer: "warehouse_transfer",branch_transfer: "branch_transfer", distributor_transfer: "distributor_transfer"}
    enum status: { pending: "pending", completed: "received", cancelled: "rejected" }
    #after_create :create_inventory_transactions

    def self.search(params, territory_id)
        stock_transfers = StockTransfer.where(
            "
            territory_id = :territory
            OR source_id = :territory
            OR destination_id = :territory
            ",
            territory: territory_id
        )

        # Search
        if params[:query].present?
            search = "%#{sanitize_sql_like(params[:query])}%"

            stock_transfers = stock_transfers.where(
            "
                description LIKE :search
                OR from_distributor LIKE :search
                OR to_distributor LIKE :search
            ",
            search: search
            )
        end

        # Transfer type
        if params[:transfer_type].present?
            stock_transfers = stock_transfers.where(
            transfer_type: params[:transfer_type]
            )
        end

        # Source
        if params[:source_id].present?
            stock_transfers = stock_transfers.where(
            source_id: params[:source_id]
            )
        end

        # Destination
        if params[:destination_id].present?
            stock_transfers = stock_transfers.where(
            destination_id: params[:destination_id]
            )
        end

        # Start date
        if params[:start_date].present?
            stock_transfers = stock_transfers.where(
            "transfer_date >= ?",
            params[:start_date]
            )
        end

        # End date
        if params[:end_date].present?
            stock_transfers = stock_transfers.where(
            "transfer_date <= ?",
            params[:end_date]
            )
        end

        stock_transfers.order(transfer_date: :desc)
        end

    def create_inventory_transactions
        return if inventory_transactions_created?

        if warehouse_transfer?

        stock_transfer_items.each do |item|
            quantity = item.transfer_quantity

            next unless quantity.present? && quantity > 0

            InventoryTransaction.create!(
            nile_product_id: item.nile_product_id,
            territory_id: self.territory_id,
            transaction_quantity: quantity,
            transaction_type: 'warehouse transfer out',
            direction: 'out',
            transaction_date: self.transfer_date
            )

            InventoryTransaction.create!(
            nile_product_id: item.nile_product_id,
            territory_id: self.territory_id,
            transaction_quantity: quantity,
            transaction_type: 'warehouse transfer in',
            direction: 'in',
            transaction_date: self.transfer_date
            )
        end

        elsif branch_transfer?

        stock_transfer_items.each do |item|
            quantity = item.transfer_quantity

            next unless quantity.present? && quantity > 0

            InventoryTransaction.create!(
            nile_product_id: item.nile_product_id,
            territory_id: self.source_id,
            transaction_quantity: quantity,
            transaction_type: 'branch transfer out',
            direction: 'out',
            transaction_date: self.transfer_date
            )

            InventoryTransaction.create!(
            nile_product_id: item.nile_product_id,
            territory_id: self.destination_id,
            transaction_quantity: quantity,
            transaction_type: 'branch transfer in',
            direction: 'in',
            transaction_date: self.transfer_date
            )
        end

        elsif distributor_transfer?

        stock_transfer_items.each do |item|
            quantity = item.transfer_quantity

            next unless quantity.present? && quantity > 0

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

        update_column(:inventory_transactions_created, true)
    end

    private

    def inventory_transactions_created?
        self.inventory_transactions_created == true
    end
end
