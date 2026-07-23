module Payments
  class ApplyCustomerCredit
    def initialize(sale)
      @sale = sale
      @customer = sale.customer
    end

    def call
      ActiveRecord::Base.transaction do
        apply_unallocated_payments
        apply_credit_memos
      end

      sale
    end

    private

    attr_reader :sale, :customer

    def apply_unallocated_payments
      available_payments.each do |payment|
        break if sale.balance <= 0

        amount_to_apply = [
          payment.available_amount,
          sale.balance
        ].min

        next unless amount_to_apply.positive?

        PaymentAllocation.create!(
          sale_payment: payment,
          sale: sale,
          amount: amount_to_apply,
          allocated_at: Time.current
        )

        payment.reload
        sale.reload
      end
    end

    def apply_credit_memos
      available_memos.each do |memo|
        break if sale.balance <= 0

        amount_to_apply = [
          memo.available_amount,
          sale.balance
        ].min

        next unless amount_to_apply.positive?

        CreditMemoAllocation.create!(
          customer_credit_memo: memo,
          sale: sale,
          amount: amount_to_apply,
          allocated_at: Time.current
        )

        memo.reload
        sale.reload
      end
    end

    def available_payments
      customer
        .sale_payments
        .includes(:payment_allocations)
        .order(:payment_date, :id)
        .select do |payment|
          payment.available_amount.positive?
        end
    end

    def available_memos
      customer
        .customer_credit_memos
        .approved
        .includes(:credit_memo_allocations)
        .order(:memo_date, :id)
        .select do |memo|
          memo.available_amount.positive?
        end
    end
  end
end