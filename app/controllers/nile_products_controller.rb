class NileProductsController < ApplicationController
  before_action :set_nile_product, only: %i[ show edit update destroy openning_stock ]

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
    @empty_types = EmptyType.all
  end

  # GET /nile_products/1/edit
  def edit
    @nile_categories = NileCategory.all
    @empty_types = EmptyType.all
  end

  # POST /nile_products or /nile_products.json
  def create
    @nile_product = NileProduct.new(nile_product_params)
    @nile_categories = NileCategory.all
    @empty_types = EmptyType.all
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
    @empty_types = EmptyType.all
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
    available_stock = InventoryTransaction.available_quantity(
      product_id: @product.id,
      territory_id: current_territory.id
    )
  
    puts "TOTAL AVAILABLE:=========#{available_stock}"
  
    render json: { available_stock: available_stock }
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
    @product = NileProduct.find(params[:id])
    @inventory_items = InventoryItem.search_stock(params, current_territory.id, params[:id]).page(params[:page]).per(20)
  end
  
  def openning_stock
    @product = NileProduct.find(params[:id])
    @transactions = InventoryTransaction.search_openning_stock(params, current_territory.id, @product.id).page(params[:page]).per(20)
  end

  def quantity_in
    @product = NileProduct.find(params[:id])
    @transactions = InventoryTransaction.search_quantity_in(params, current_territory.id, @product.id).page(params[:page]).per(20)
  end

  def breakages
    @product = NileProduct.find(params[:id])
  end
  def create_breakage
    @product = NileProduct.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nile_product
      @nile_product = NileProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def nile_product_params
      params.require(:nile_product).permit(:name, :crate_size, :bottle_size, :pcode, :nile_category_id, :buying_price, :selling_price, :empty_type_id)
    end
    def breakage_params
      params.require(:inventory_item).permit(:nile_product_id, :breakages)
    end
end
