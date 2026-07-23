module Credits
  class ApplyCreditMemo
    def initialize(credit_memo)
      @credit_memo = credit_memo
      @customer = credit_memo.customer
    end

    def call
      return credit_memo unless credit_memo.approved?

      customer
        .sales
        .order(:sale_date, :id)
        .each do |sale|

        break if credit_memo.available_amount <= 0

        next if sale.balance <= 0

        amount_to_apply = [
          credit_memo.available_amount,
          sale.balance
        ].min

        next unless amount_to_apply.positive?

        CreditMemoAllocation.create!(
          customer_credit_memo: credit_memo,
          sale: sale,
          amount: amount_to_apply,
          allocated_at: Time.current
        )

        credit_memo.reload
        sale.reload
      end

      credit_memo
    end

    private

    attr_reader :credit_memo, :customer
  end
end