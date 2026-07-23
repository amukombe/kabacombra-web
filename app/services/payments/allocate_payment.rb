module Payments
  class AllocatePayment
    def initialize(payment:, preferred_sale: nil)
      @payment = payment
      @preferred_sale = preferred_sale
    end

    def call
      ActiveRecord::Base.transaction do
        allocate_to_preferred_sale
        allocate_to_other_open_sales
      end

      payment
    end

    private

    attr_reader :payment, :preferred_sale

    def allocate_to_preferred_sale
      return if preferred_sale.blank?
      return if payment.available_amount <= 0
      return if preferred_sale.balance <= 0

      allocate(preferred_sale)
    end

    def allocate_to_other_open_sales
      customer_sales.each do |sale|
        break if payment.available_amount <= 0

        next if preferred_sale.present? &&
                sale.id == preferred_sale.id

        next if sale.balance <= 0

        allocate(sale)
      end
    end

    def customer_sales
      payment.customer
             .sales
             .order(:sale_date, :id)
    end

    def allocate(sale)
      allocation_amount = [
        payment.available_amount,
        sale.balance
      ].min

      return unless allocation_amount.positive?

      PaymentAllocation.create!(
        sale_payment: payment,
        sale: sale,
        amount: allocation_amount,
        allocated_at: Time.current
      )
    end
  end
end