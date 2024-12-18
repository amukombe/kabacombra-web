class RequestsController < ApplicationController
  def driver_request
    @orders = Order.where(status_id: 1).search(params).page(params[:page]).per(20)
  end
end
