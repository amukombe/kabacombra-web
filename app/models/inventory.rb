class Inventory < ApplicationRecord
  belongs_to :beer_dispatch, optional: true
  has_many :inventory_items, dependent: :destroy
  belongs_to :user
  belongs_to :warehouse
  accepts_nested_attributes_for :inventory_items, allow_destroy: true, reject_if: :all_blank
  
  def self.search(params, territory_id)

    query = joins(:beer_dispatch)
              .where(
                territory_id: territory_id,
                beer_dispatches: {
                  status_id: [13]
                }
              )

    # Search
    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.where(
        "beer_dispatches.fdn_number LIKE :search
        OR beer_dispatches.dispatch_no LIKE :search",
        search: search
      )
    end

    # Start date
    if params[:start_date].present?
      query = query.where(
        "DATE(beer_dispatches.loading_time) >= ?",
        params[:start_date]
      )
    end

    # End date
    if params[:end_date].present?
      query = query.where(
        "DATE(beer_dispatches.loading_time) <= ?",
        params[:end_date]
      )
    end

    query
  end

  def self.search_received(params, territory_id)

    query = joins(:beer_dispatch)
              .where(
                territory_id: territory_id,
                beer_dispatches: {
                  status_id: [4, 13]
                }
              )

    # Search filter
    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.where(
        "beer_dispatches.fdn_number LIKE :search
        OR beer_dispatches.dispatch_no LIKE :search",
        search: search
      )
    end

    # Start date filter
    if params[:start_date].present?
      query = query.where(
        "DATE(beer_dispatches.loading_time) >= ?",
        params[:start_date]
      )
    end

    # End date filter
    if params[:end_date].present?
      query = query.where(
        "DATE(beer_dispatches.loading_time) <= ?",
        params[:end_date]
      )
    end

    query
  end

  def total_price
    inventory_items.sum(&:total)
  end
  def total_Purchase
    total_price
  end
end
