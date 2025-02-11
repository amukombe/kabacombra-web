class Sale < ApplicationRecord
  enum mode_of_payment: { cash: "cash",credit: "credit", momopay: "momopay", airtelpay: "airtelpay", bank: "bank" }

  belongs_to :user
  belongs_to :territory
  belongs_to :status
  has_many :sale_items, dependent: :destroy
  accepts_nested_attributes_for :sale_items, allow_destroy: true, reject_if: :all_blank
  has_many :sale_empties, dependent: :destroy
  accepts_nested_attributes_for :sale_empties, allow_destroy: true, reject_if: :all_blank
  
  validates :sale_date, :mode_of_payment, presence: true
  validate :sufficient_stock
  before_destroy :restore_quantity
  before_validation :generate_receipt_number, on: :create

  def self.search(params)
    params[:query].blank? ? all : where("receipt_no LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end

  def total_price
    sale_items.sum(&:total)
  end

  private
  def sufficient_stock
    sale_items.each do |sale_item|
      if sale_item.quantity_sold > sale_item.loading_order_item.remaining_quantity
        errors.add(:base, "Quantity sold for #{sale_item.loading_order_item.nile_product.name} exceeds available stock")
      end
    end
  end
  def restore_quantity
    sale_items.each do |sale_item|
      sale_item.loading_order_item.remaining_quantity += sale_item.quantity_sold
      sale_item.loading_order_item.save!
    end
  end
  
  def generate_receipt_number
    if self.receipt_no.blank?
      last_order = Sale.order(:created_at).last
      next_number = last_order&.receipt_no.to_i + 1 || 1
      self.receipt_no = next_number.to_s.rjust(5, '0')
    end
  end
end
