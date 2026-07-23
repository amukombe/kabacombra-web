module Payments
  class AllocateSalePayment
    def initialize(sale_payment:, preferred_sale: nil)
      @sale_payment = sale_payment
      @preferred_sale = preferred_sale
    end

    def call
      ActiveRecord::Base.transaction do
        allocate_to_preferred_sale
        allocate_to_other_unpaid_sales
      end

      sale_payment
    end

    private

    attr_reader :sale_payment, :preferred_sale

    def allocate_to_preferred_sale
      return if preferred_sale.blank?
      return unless same_customer?(preferred_sale)
      return if sale_payment.available_amount <= 0
      return if preferred_sale.balance <= 0

      allocate_to(preferred_sale)
    end

    def allocate_to_other_unpaid_sales
      customer_sales.each do |sale|
        break if sale_payment.available_amount <= 0

        next if preferred_sale.present? &&
                sale.id == preferred_sale.id

        next if sale.balance <= 0

        allocate_to(sale)
      end
    end

    def customer_sales
      sale_payment.customer
                  .sales
                  .order(:sale_date, :id)
    end

    def allocate_to(sale)
      allocation_amount = [
        sale_payment.available_amount,
        sale.balance
      ].min

      return unless allocation_amount.positive?

      PaymentAllocation.create!(
        sale_payment: sale_payment,
        sale: sale,
        amount: allocation_amount,
        allocated_at: Time.current
      )
    end

    def same_customer?(sale)
      sale.customer_id == sale_payment.customer_id
    end
  end
end