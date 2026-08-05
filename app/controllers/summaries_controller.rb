class SummariesController < ApplicationController
  before_action :load_banking_data, only: [:banking]

  def banking
    @active_link = "banking"

    load_dashboard_cards
    load_recent_transactions
    load_bank_accounts
    load_recent_deposits
    load_recent_withdrawals
  end

  private

    def load_banking_data
      @territory = current_territory
    end

    ############################################################
    # Dashboard Cards
    ############################################################

    def load_dashboard_cards

      @bank_accounts =
        @territory.bank_accounts

      @bank_account_count =
        @bank_accounts.count

      @total_deposits =
        @territory.bank_deposits.sum(:amount)

      @total_withdrawals =
        @territory.bank_withdraws.sum(:amount)

      @total_transfers =
        @territory.bank_transfers.sum(:amount)

      @supplier_payments =
        Payment
          .where(
            territory: @territory,
            recipient_type: "Supplier"
          )
          .sum(:amount)

      @employee_payments =
        Payment
          .where(
            territory: @territory,
            recipient_type: "Employee"
          )
          .sum(:amount)

      @total_cash =
        @bank_accounts.sum do |account|
          account.current_balance
        end

      @net_cash_position =
        @total_cash

    end

    ############################################################
    # Recent Transactions
    ############################################################

    def load_recent_transactions

      @recent_transactions =
        @territory
          .bank_transactions
          .includes(:bank_account)
          .order(
            cleared_date: :desc,
            created_at: :desc
          )
          .limit(15)

    end

    ############################################################
    # Accounts
    ############################################################

    def load_bank_accounts

      @accounts =
        @territory
          .bank_accounts
          .includes(:bank)

    end

    ############################################################
    # Deposits
    ############################################################

    def load_recent_deposits

      @recent_deposits =
        @territory
          .bank_deposits
          .includes(:bank_account)
          .order(
            deposit_date: :desc
          )
          .limit(5)

    end

    ############################################################
    # Withdrawals
    ############################################################

    def load_recent_withdrawals

      @recent_withdrawals =
        @territory
          .bank_withdraws
          .includes(:bank_account)
          .order(
            withdraw_date: :desc
          )
          .limit(5)

    end
end