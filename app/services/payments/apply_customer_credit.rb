module Payments
  class ApplyCustomerCredit
    def initialize(sale)
      @sale = sale
      @customer = sale.customer
    end

    def call
      ActiveRecord::Base.transaction do
        available_sale_payments.each do |sale_payment|
          break if sale.balance <= 0

          allocation_amount = [
            sale_payment.available_amount,
            sale.balance
          ].min

          next unless allocation_amount.positive?

          PaymentAllocation.create!(
            sale_payment: sale_payment,
            sale: sale,
            amount: allocation_amount,
            allocated_at: Time.current
          )
        end
      end

      sale
    end

    private

    attr_reader :sale, :customer

    def available_sale_payments
      customer
        .sale_payments
        .includes(:payment_allocations)
        .order(:payment_date, :id)
        .select do |sale_payment|
          sale_payment.available_amount.positive?
        end
    end
  end
end