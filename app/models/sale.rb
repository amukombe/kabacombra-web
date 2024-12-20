class Sale < ApplicationRecord
  enum sale_type: { normal: "normal", fbi: "fbi" }
  enum mode_of_payment: { cash: "cash",credit: "credit", momopay: "momopay", airtelpay: "airtelpay", bank: "bank" }

  belongs_to :loading_order_item
  belongs_to :customer
  belongs_to :user
  has_many :sale_items
  accepts_nested_attributes_for :sale_items, allow_destroy: true, reject_if: :all_blank
  def self.search(params)
    params[:query].blank? ? all : where("receipt_no LIKE?", "%#{sanitize_sql_like(params[:query])}%")
  end

  def total_price
    sale_items.sum(&:total)
  end
end
