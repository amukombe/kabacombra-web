class SummariesController < ApplicationController
  def banking
    @active_link = "banking"
    @territory = Territory.find(current_territory.id)
    @recent_transactions = @territory.financial_transactions.order(created_at: :desc).limit(10)
    @accounts = @territory.bank_accounts
    @total_balance = @accounts.map(&:balance).sum
    @total_income = @territory.financial_transactions.where(transaction_type: "deposit").sum(:amount)
    @total_expenses = @territory.financial_transactions.where(transaction_type: "payment").sum(:amount)
  end
end
