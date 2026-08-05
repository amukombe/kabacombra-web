# app/services/statements/statement_builder.rb

module Statements
  class StatementBuilder

    attr_reader :rows,
                :opening_balance,
                :closing_balance,
                :total_debits,
                :total_credits

    def initialize(opening_balance:, transactions:)

      @opening_balance = opening_balance.to_d
      @transactions = Array(transactions)

      @rows = []

      @total_debits = 0.to_d
      @total_credits = 0.to_d
      @closing_balance = @opening_balance

    end

    def call

      balance = opening_balance

      rows << Statements::Entry.new(
        date: nil,
        reference: "",
        description: "Opening Balance",
        debit: 0,
        credit: 0,
        record: nil,
        metadata: {
          row_type: :opening,
          balance: balance
        }
      )

      @transactions.each do |entry|

        debit = entry.debit.to_d
        credit = entry.credit.to_d

        balance += debit
        balance -= credit

        @total_debits += debit
        @total_credits += credit

        rows << Statements::Entry.new(
          date: entry.date,
          reference: entry.reference,
          description: entry.description,
          debit: debit,
          credit: credit,
          record: entry.record,
          metadata: entry.metadata.merge(
            row_type: :transaction,
            balance: balance
          )
        )

      end

      @closing_balance = balance

      self

    end

    def summary

      {
        opening_balance: opening_balance,
        total_debits: total_debits,
        total_credits: total_credits,
        closing_balance: closing_balance
      }

    end

  end
end