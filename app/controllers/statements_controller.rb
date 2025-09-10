class StatementsController < ApplicationController
  def vendor_statement
    @active_link='summary'
  end

  def beer_purchases
    @active_link='beer purchases'
    @territory = Territory.find(current_territory.id)
    @orders = @territory.inventories.page(params[:page]).per(10) # Order.search_vendor_purchases(params, current_territory.id).page(params[:page]).per(20)
  end

  def empty_returns
    @active_link='empty returns'
  end

  def payments
    @active_link='payments'
    @vendor_payments = current_territory.vendor_payments.page(params[:page]).per(20)
  end

  def adjustments
    @active_link='adjustments'
    @territory = Territory.find(current_territory.id)
    @vendor_adjustiments = @territory.vendor_adjustiments.order(created_at: :desc).page(params[:page]).per(15)
  end
end
