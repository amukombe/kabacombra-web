class LoadingOrder < ApplicationRecord
  belongs_to :user
  belongs_to :territory
  has_many :loading_order_items, dependent: :destroy
  belongs_to :status
  belongs_to :store, optional: true
  accepts_nested_attributes_for :loading_order_items, allow_destroy: true, reject_if: :all_blank
  validates :loading_date, :order_number, :sales_man, :authorized_by, :verified_by, presence: true
  before_validation :generate_order_number, on: :create
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
end
