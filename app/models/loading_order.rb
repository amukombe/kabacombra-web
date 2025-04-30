class LoadingOrder < ApplicationRecord
  belongs_to :user
  belongs_to :territory
  has_many :loading_order_items, dependent: :destroy
  belongs_to :status
  belongs_to :store, optional: true
  accepts_nested_attributes_for :loading_order_items, allow_destroy: true, reject_if: :all_blank
  validates :loading_date, :order_number, :sales_man, :authorized_by, presence: true
  before_validation :generate_order_number, on: :create
  after_create :create_inventory_transactions
  
  def self.search(params, territory_id)
    if params[:query].present?
      where("order_number LIKE ? AND status_id IN (?) AND territory_id = ?", "%#{sanitize_sql_like(params[:query])}%", [6,7], territory_id)
    else
      where(status_id: [6,7], territory_id: territory_id)
    end
  end

  def self.my_approvals(params, territory_id, user_id, status_id)
    query = where("status_id IN (?) AND territory_id = ? AND authorized_by = ?", [6], territory_id, user_id)
  
    if params[:query].present?
      query = query.where("order_number LIKE ?", "%#{sanitize_sql_like(params[:query])}%")
    end
  
    query
  end

  private
  def generate_order_number
    if self.order_number.blank?
      last_order = LoadingOrder.order(:created_at).last
      next_number = last_order&.order_number.to_i + 1 || 1
      self.order_number = next_number.to_s.rjust(5, '0')
    end
  end

  def create_inventory_transactions
    loading_order_items.each do |item|
      quantity = item.quantity_loaded
      next unless quantity.present? && quantity > 0

      InventoryTransaction.create!(
        nile_product_id: item.nile_product_id,
        territory_id: self.territory_id,
        transaction_quantity: quantity,
        transaction_type: 'distribution',
        direction: 'out',
        transaction_date: self.loading_date
      )
    end
  end

  private

  def generate_order_number
    return if order_number.present? || territory.blank?

    prefix = territory.name[0, 3].upcase
    last_order = LoadingOrder.where(territory_id: territory.id)
                             .order(order_number: :desc)
                             .where("order_number LIKE ?", "#{prefix}-%")
                             .first

    if last_order&.order_number.present?
      last_number = last_order.order_number.split('-').last.to_i
      next_number = last_number + 1
    else
      next_number = 1
    end

    self.order_number = "#{prefix}-#{next_number.to_s.rjust(7, '0')}"
  end
end
