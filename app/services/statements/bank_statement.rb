# app/services/statements/bank_statement.rb

module Statements
  class BankStatement

    attr_reader :builder

    def initialize(
      bank_account:,
      start_date:,
      end_date:
    )

      @bank_account = bank_account
      @start_date = start_date.to_date
      @end_date = end_date.to_date

    end

    ###########################################################
    # Build Statement
    ###########################################################

    def call

      builder =
        Statements::StatementBuilder.new(

          opening_balance: opening_balance,

          transactions: entries

        ).call

      @builder = builder

      self

    end

    ###########################################################
    # Rows
    ###########################################################

    def rows
      builder.rows
    end

    ###########################################################
    # Summary
    ###########################################################

    def summary
      builder.summary
    end

    ###########################################################
    # Closing Balance
    ###########################################################

    def closing_balance
      builder.closing_balance
    end

    private

    ###########################################################
    # Opening Balance
    ###########################################################

    def opening_balance

      previous =
        @bank_account
          .bank_transactions
          .where(
            "cleared_date < ?",
            @start_date
          )

      deposits =
        previous
          .where(method: "deposit")
          .sum(:amount)

      withdrawals =
        previous
          .where
          .not(method: "deposit")
          .sum(:amount)

      deposits - withdrawals

    end

    ###########################################################
    # Entries
    ###########################################################

    def entries

      transactions =
        @bank_account
          .bank_transactions
          .includes(:financial_transaction)
          .where(
            cleared_date:
              @start_date..
              @end_date
          )
          .order(
            :cleared_date,
            :created_at
          )

      transactions.map do |transaction|

        Statements::Entry.new(

          date:
            transaction.cleared_date,

          reference:
            transaction.financial_transaction&.reference ||
            transaction.cheque_number,

          description:
            transaction.transaction_type.titleize,

          debit:
            transaction.method == "deposit" ?
              transaction.amount : 0,

          credit:
            transaction.method == "deposit" ?
              0 : transaction.amount,

          record:
            transaction

        )

      end

    end

  end

end