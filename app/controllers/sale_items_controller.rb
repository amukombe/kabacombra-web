class SaleItemsController < ApplicationController
  before_action :set_sale_item, only: %i[ show edit update destroy ]

  # GET /sale_items or /sale_items.json
  def index
    @sale_items = SaleItem.all
  end

  # GET /sale_items/1 or /sale_items/1.json
  def show
  end

  # GET /sale_items/new
  def new
    @sale_item = SaleItem.new
  end

  # GET /sale_items/1/edit
  def edit
  end

  # POST /sale_items or /sale_items.json
  def create
    @sale_item = SaleItem.new(sale_item_params)

    respond_to do |format|
      if @sale_item.save
        format.html { redirect_to @sale_item, notice: "Sale item was successfully created." }
        format.json { render :show, status: :created, location: @sale_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale_items/1 or /sale_items/1.json
  def update
    respond_to do |format|
      if @sale_item.update(sale_item_params)
        format.html { redirect_to @sale_item, notice: "Sale item was successfully updated." }
        format.json { render :show, status: :ok, location: @sale_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_items/1 or /sale_items/1.json
  def destroy
    @sale_item.destroy!

    respond_to do |format|
      format.html { redirect_to sale_items_path, status: :see_other, notice: "Sale item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_item
      @sale_item = SaleItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sale_item_params
      params.require(:sale_item).permit(:loading_order_item_id, :quantity_sold, :amount, :total)
    end
end
