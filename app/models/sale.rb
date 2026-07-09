class Sale < ApplicationRecord
  enum mode_of_payment: {
    cash: "cash",
    credit: "credit"
  }

  belongs_to :user
  belongs_to :territory
  belongs_to :customer
  belongs_to :status
  belongs_to :store, optional: true

  has_many :sale_items, dependent: :destroy
  accepts_nested_attributes_for :sale_items, allow_destroy: true, reject_if: :all_blank
  has_many :sale_payments, dependent: :destroy

  validates :sale_date, :mode_of_payment, presence: true

  validate :sufficient_stock

  before_validation :generate_document_numbers, on: :create
  before_create :create_customer_if_missing

  after_create :update_loading_order_status
  after_update :update_loading_order_status
  # after_destroy :update_loading_order_status
  before_destroy :store_loading_order_ids
  after_destroy :update_loading_order_status_after_destroy

  after_save :recalculate_loading_order_quantities
  after_destroy :recalculate_loading_order_quantities

  after_save :update_remaining_quantities
  before_destroy :restore_quantity

  def self.search(params)
    query = all

    # Search
    if params[:query].present?
      search = "%#{sanitize_sql_like(params[:query])}%"

      query = query.where(
        "receipt_no LIKE :search
        OR invoice_no LIKE :search
        OR customer_name LIKE :search
        OR customer_mobile LIKE :search
        OR mode_of_payment LIKE :search",
        search: search
      )
    end

    # From Date
    if params[:start_date].present?
      query = query.where(
        "DATE(sale_date) >= ?",
        params[:start_date]
      )
    end

    # To Date
    if params[:end_date].present?
      query = query.where(
        "DATE(sale_date) <= ?",
        params[:end_date]
      )
    end

    query
  end

  def total_price
    sale_items.sum(&:total)
  end
  # payment validations
  def paid_amount
    sale_payments.sum(&:amount)
  end

  def balance
    total_price - paid_amount
  end

  def last_payment_reference
    sale_payments.order(:created_at).last&.receipt_number || receipt_number
  end

  def fully_paid?
    balance <= 0
  end

  private

  def update_loading_order_status
    loading_order_ids = sale_items
      .joins(:loading_order_item)
      .pluck("loading_order_items.loading_order_id")
      .uniq

    LoadingOrder.where(id: loading_order_ids).find_each do |loading_order|

      all_sold = loading_order.loading_order_items.all? do |item|
        item.sale_items.sum(:quantity_sold) >= item.quantity_loaded
      end

      loading_order.update_column(
        :status_id,
        all_sold ? 7 : 6
      )
    end
  end

  def update_remaining_quantities
    sale_items.each do |sale_item|
      loading_item = sale_item.loading_order_item

      sold_quantity = loading_item.sale_items.sum(:quantity_sold)

      loading_item.update_column(
        :remaining_quantity,
        loading_item.quantity_loaded - sold_quantity
      )
    end
  end

  def create_customer_if_missing
    return if customer_name.blank?

    customer = Customer.find_by(
      name: customer_name,
      territory_id: territory_id
    )

    return self.customer_id = customer.id if customer.present?

    customer = Customer.create!(
      name: customer_name,
      mobile: customer_mobile,
      brn: tin,
      territory_id: territory_id
    )

    self.customer_id = customer.id
  end

  def sufficient_stock
    sale_items.each do |sale_item|
      next if sale_item.loading_order_item.blank?

      loading_item = sale_item.loading_order_item

      sold_quantity = SaleItem
        .where(loading_order_item_id: loading_item.id)
        .where.not(id: sale_item.id)
        .sum(:quantity_sold)

      available_quantity =
        loading_item.quantity_loaded - sold_quantity

      if sale_item.quantity_sold > available_quantity
        errors.add(
          :base,
          "#{sale_item.nile_product.name} only has #{available_quantity} remaining from the loading order"
        )
      end
    end
  end

  def restore_quantity
    sale_items.each do |sale_item|
      StoreTransaction.create!(
        nile_product_id: sale_item.nile_product_id,
        territory_id: territory_id,
        user_id: user_id,
        store_id: store_id,
        quantity: sale_item.quantity_sold,
        direction: "in",
        movement_type: "sale return",
        notes: "Restored stock from deleted sale",
        transaction_date: Date.current
      )
    end
  end

  def generate_document_numbers
    generate_invoice_number

    # unless credit?
      # generate_receipt_number
    # end
  end

  def generate_receipt_number
    return if receipt_no.present?

    year  = Date.current.strftime("%y")
    month = Date.current.strftime("%m")

    prefix = "RPT/#{year}/#{month}/"

    last_receipt = Sale
      .where("receipt_no LIKE ?", "#{prefix}%")
      .order(:created_at)
      .last

    next_number =
      if last_receipt.present?
        last_receipt.receipt_no.split("/").last.to_i + 1
      else
        1
      end

    self.receipt_no = "#{prefix}#{next_number.to_s.rjust(5, '0')}"
  end

  def generate_invoice_number
    return if invoice_no.present?

    year  = Date.current.strftime("%y")
    month = Date.current.strftime("%m")

    prefix = "INV/#{year}/#{month}/"

    last_invoice = Sale
      .where("invoice_no LIKE ?", "#{prefix}%")
      .order(:created_at)
      .last

    next_number =
      if last_invoice.present?
        last_invoice.invoice_no.split("/").last.to_i + 1
      else
        1
      end

    self.invoice_no = "#{prefix}#{next_number.to_s.rjust(5, '0')}"
  end

  def store_loading_order_ids
    @loading_order_ids = sale_items
      .joins(:loading_order_item)
      .pluck("loading_order_items.loading_order_id")
      .uniq
  end

  def update_remaining_quantities_after_destroy
    return unless @loading_order_ids.present?

    LoadingOrder.where(id: @loading_order_ids).each do |loading_order|
      loading_order.loading_order_items.each do |item|
        sold_quantity = item.sale_items.sum(:quantity_sold)

        item.update_column(
          :remaining_quantity,
          item.quantity_loaded - sold_quantity
        )
      end
    end
  end

  def update_loading_order_status_after_destroy
    return unless @loading_order_ids.present?

    LoadingOrder.where(id: @loading_order_ids).each do |loading_order|
      all_sold = loading_order.loading_order_items.all? do |item|
        item.sale_items.sum(:quantity_sold) >= item.quantity_loaded
      end

      loading_order.update_column(
        :status_id,
        all_sold ? 7 : 6
      )
    end
  end

  def recalculate_loading_order_quantities
    loading_order_ids = sale_items
      .joins(:loading_order_item)
      .pluck("loading_order_items.loading_order_id")
      .uniq

    LoadingOrder.where(id: loading_order_ids).each do |loading_order|
      loading_order.loading_order_items.each do |item|
        sold_quantity = item.sale_items.sum(:quantity_sold)

        item.update_column(
          :remaining_quantity,
          item.quantity_loaded - sold_quantity
        )
      end
    end
  end
end