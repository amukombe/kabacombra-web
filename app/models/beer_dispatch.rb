class BeerDispatch < ApplicationRecord
  belongs_to :order
  belongs_to :user
  has_one :inventory, dependent: :destroy
  has_many :dispatch_items, dependent: :destroy
  accepts_nested_attributes_for :dispatch_items, allow_destroy: true, reject_if: :all_blank
  before_validation :generate_dispatch_number, on: :create
  validates :fdn_number, :driver_name, :driver_mobile, :truck_numberplate, :delivery_plant, :shipping_point, :loading_time, presence: true
  
  def self.search(params, territory_id)

    query = joins(:order)
              .where(
                territory_id: territory_id,
                orders: {
                  status_id: [3, 4]
                }
              )

    # Search
    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.where(
        "beer_dispatches.fdn_number LIKE :search
        OR orders.order_number LIKE :search",
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

  def total_price
    dispatch_items.sum { |item| item.quantity_dispatched * item.order_item.unit_price }
  end  

  private
  def generate_dispatch_number
    if self.dispatch_no.blank?
      last_dispatch = BeerDispatch.order(:created_at).last
      next_number = last_dispatch&.dispatch_no.to_i + 1 || 1
      self.dispatch_no = next_number.to_s.rjust(5, '0')
    end
  end
end
