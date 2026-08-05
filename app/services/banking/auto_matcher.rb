module Banking

  class AutoMatcher

    def initialize(reconciliation)
      @reconciliation = reconciliation
      @account = reconciliation.bank_account
    end

    def call

      @reconciliation
        .bank_reconciliation_items
        .where(matched: false)
        .find_each do |item|

        transaction =
          matching_transaction(item)

        next unless transaction

        item.update!(

          matched: true,

          matched_transaction: transaction,

          matched_at: Time.current

        )

      end

    end

    private

    def matching_transaction(item)

      @account
        .bank_transactions
        .where(amount: item.bank_amount)
        .where(
          cleared_date:
            item.bank_date - 3.days..
            item.bank_date + 3.days
        )
        .find do |transaction|

          references_match?(
            transaction,
            item
          )

        end

    end

    def references_match?(transaction, item)

      transaction
        .financial_transaction
        &.reference
        .to_s
        .strip
        .casecmp?(
          item.bank_reference.to_s.strip
        )

    end

  end

end