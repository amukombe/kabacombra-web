class BeerDispatchesController < ApplicationController
  before_action :set_beer_dispatch, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  # GET /beer_dispatches or /beer_dispatches.json
  def index
    #@oder = Order.find(params[:id])
    @dispatches = BeerDispatch.search(params, current_territory.id).page(params[:page]).per(20)
  end

  # GET /beer_dispatches/1 or /beer_dispatches/1.json
  def show
  end

  # GET /beer_dispatches/new
  def new
    puts "CURRENT USER: #{current_user.id}"
    @order = Order.find(params[:id])
    @beer_dispatch = BeerDispatch.new
    # Build dispatch items based on existing order items
    @order.order_items.each do |order_item|
      @beer_dispatch.dispatch_items.build(
        order_item_id: order_item.id, 
        quantity_ordered: order_item.quantity,
        quantity_dispatched: order_item.quantity
      )
    end
    #@beer_dispatch.dispatch_items.build
    @drivers = @order.drivers
    @order_items = @order.order_items

  end

  # GET /beer_dispatches/1/edit
  def edit
    #@beer_dispatch.dispatch_items.build(beer_dispatch_params)
    @order = Order.find(@beer_dispatch.order_id)
    @drivers = @order.drivers
    @order_items = @order.order_items
  end

  # POST /beer_dispatches or /beer_dispatches.json
  def create
    order_id = beer_dispatch_params[:order_id]
    @order = Order.find(order_id)
    @beer_dispatch = BeerDispatch.new(beer_dispatch_params)
    @drivers = @order.drivers
    @order_items = @order.order_items
    respond_to do |format|
      if @beer_dispatch.save
        @order.update(status_id: 3)
        format.html { redirect_to orders_path, notice: "Beer dispatch was successfully created." }
        format.json { render :show, status: :created, location: @beer_dispatch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beer_dispatch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beer_dispatches/1 or /beer_dispatches/1.json
  def update
    @order = Order.find(params[:id])
    @beer_dispatch.dispatch_items.build(beer_dispatch_params)
    @drivers = @order.drivers
    @order_items = @order.order_items
    respond_to do |format|
      if @beer_dispatch.update(beer_dispatch_params)
        format.html { redirect_to @beer_dispatch, notice: "Beer dispatch was successfully updated." }
        format.json { render :show, status: :ok, location: @beer_dispatch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer_dispatch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beer_dispatches/1 or /beer_dispatches/1.json
  def destroy
    @beer_dispatch.destroy!

    respond_to do |format|
      format.html { redirect_to beer_dispatches_path, status: :see_other, notice: "Beer dispatch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def dispatch_pdf
    @dispatch = BeerDispatch.find(params[:id]) 
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name", template: "beer_dispatches/dispatch_pdf", formats: [:html], disposition: :inline, layout: 'pdf'   # Excluding ".pdf" extension.
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer_dispatch
      @beer_dispatch = BeerDispatch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def beer_dispatch_params
      params.require(:beer_dispatch).permit(:fdn_number, :truck_numberplate, :trailer_plate, :second_trailer, :delivery_plant, :shipping_point, :loading_time, :delivery_plant, :driver_id, :order_id, :dispatch_no, :user_id,:territory_id,
      dispatch_items_attributes: [:id,:beer_dispatch_id, :order_item_id, :quantity_dispatched, :quantity_ordered, :_destroy])
    end
end
