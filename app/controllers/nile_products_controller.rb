class NileProductsController < ApplicationController
  before_action :set_nile_product, only: %i[ show edit update destroy ]

  # GET /nile_products or /nile_products.json
  def index
    @nile_products = NileProduct.search(params).page(params[:page]).per(20)
  end

  # GET /nile_products/1 or /nile_products/1.json
  def show
  end

  # GET /nile_products/new
  def new
    @nile_product = NileProduct.new
    @nile_categories = NileCategory.all
  end

  # GET /nile_products/1/edit
  def edit
    @nile_categories = NileCategory.all
  end

  # POST /nile_products or /nile_products.json
  def create
    @nile_product = NileProduct.new(nile_product_params)
    @nile_categories = NileCategory.all
    respond_to do |format|
      if @nile_product.save
        format.html { redirect_to nile_products_path, notice: "Nile product was successfully created." }
        format.json { render :show, status: :created, location: @nile_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @nile_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nile_products/1 or /nile_products/1.json
  def update
    @nile_categories = NileCategory.all
    respond_to do |format|
      if @nile_product.update(nile_product_params)
        format.html { redirect_to nile_products_path, notice: "Nile product was successfully updated." }
        format.json { render :show, status: :ok, location: @nile_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @nile_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nile_products/1 or /nile_products/1.json
  def destroy
    @nile_product.destroy!

    respond_to do |format|
      format.html { redirect_to nile_products_path, status: :see_other, notice: "Nile product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def available_stock
    # Fetch the product based on the provided ID
  @product = NileProduct.find(params[:id])

  # Join InventoryItem with Inventory and filter by territory_id
  total_available_stock = InventoryItem.joins(:inventory, dispatch_item: { order_item: :nile_product }).where(inventories: {territory_id: current_territory.id},nile_products:{id: @product.id})
                                       .sum("quantity_received - quantity_sold")
  puts "TOTAL AVAILABLE:=========#{total_available_stock}"
  # Return the available stock in JSON format
  render json: { available_stock: total_available_stock }
  end

  def details
    product = NileProduct.find_by(id: params[:id])
    if product
      render json: {
        unit_price: product.buying_price,
        selling_price: product.selling_price
      }
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def dispatchdetails
    dispatch_item = DispatchItem.find_by(id: params[:id])
    product = dispatch_item.order_item.nile_product #NileProduct.find_by(id: params[:id])
    if product
      render json: {
        unit_price: product.buying_price,
        selling_price: product.selling_price
      }
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def orderitemdetails
    loading_order_item = LoadingOrderItem.find_by(id: params[:id])
    product = loading_order_item.nile_product #NileProduct.find_by(id: params[:id])
    if product
      render json: {
        unit_price: product.buying_price,
        selling_price: product.selling_price
      }
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def stock_details
    @inventory_items = InventoryItem.search_stock(params, current_territory.id, params[:id]).page(params[:page]).per(20)
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nile_product
      @nile_product = NileProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def nile_product_params
      params.require(:nile_product).permit(:name, :crate_size, :bottle_size, :pcode, :nile_category_id, :buying_price, :selling_price, :empty_type, :empty_price)
    end
end
