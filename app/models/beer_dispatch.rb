class BeerDispatch < ApplicationRecord
  belongs_to :order
  belongs_to :user
  has_one :inventory, dependent: :destroy
  has_many :dispatch_items, dependent: :destroy
  accepts_nested_attributes_for :dispatch_items, allow_destroy: true, reject_if: :all_blank
  before_validation :generate_dispatch_number, on: :create
  validates :fdn_number, :driver_name, :driver_mobile, :truck_numberplate, :delivery_plant, :shipping_point, :loading_time, presence: true
  
  def self.search(params, territory_id)
    if params[:query].present?
      joins(:order).where("fdn_number LIKE ? AND orders.status_id = ? AND territory_id = ?", "%#{sanitize_sql_like(params[:query])}%", 3, territory_id)
    else
      joins(:order).where(orders: { status_id: 3 }, territory_id: territory_id)
    end
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
