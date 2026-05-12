class BeerReturn < ApplicationRecord
  belongs_to :loading_order
  has_many :beer_return_items, dependent: :destroy
  belongs_to :territory
  accepts_nested_attributes_for :beer_return_items, allow_destroy: true
  after_create :create_inventory_transactions
  def total_returned
    beer_return_items.sum(:quantity_returned) 
  end

  def self.search(params, territory_id)

    query = where(
      territory_id: territory_id
    )

    # Search filter
    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.where(
        "product_name LIKE :search",
        search: search
      )
    end

    # Start date filter
    if params[:start_date].present?
      query = query.where(
        "DATE(return_date) >= ?",
        params[:start_date]
      )
    end

    # End date filter
    if params[:end_date].present?
      query = query.where(
        "DATE(return_date) <= ?",
        params[:end_date]
      )
    end

    query
  end

  private 
  def create_inventory_transactions
    beer_return_items.each do |item|
      quantity = item.quantity_returned
      next unless quantity.present? && quantity > 0

      InventoryTransaction.create!(
        nile_product_id: item.nile_product_id,
        territory_id: self.territory_id,
        transaction_quantity: quantity,
        transaction_type: 'return',
        direction: 'in',
        transaction_date: self.return_date
      )
    end
  end
end
