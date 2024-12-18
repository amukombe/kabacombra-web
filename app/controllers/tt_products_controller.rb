class TtProductsController < ApplicationController
  before_action :set_tt_product, only: %i[ show edit update destroy ]

  # GET /tt_products or /tt_products.json
  def index
    @tt_products = TtProduct.all
  end

  # GET /tt_products/1 or /tt_products/1.json
  def show
  end

  # GET /tt_products/new
  def new
    @tt_product = TtProduct.new
  end

  # GET /tt_products/1/edit
  def edit
  end

  # POST /tt_products or /tt_products.json
  def create
    @tt_product = TtProduct.new(tt_product_params)

    respond_to do |format|
      if @tt_product.save
        format.html { redirect_to @tt_product, notice: "Tt product was successfully created." }
        format.json { render :show, status: :created, location: @tt_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tt_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tt_products/1 or /tt_products/1.json
  def update
    respond_to do |format|
      if @tt_product.update(tt_product_params)
        format.html { redirect_to @tt_product, notice: "Tt product was successfully updated." }
        format.json { render :show, status: :ok, location: @tt_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tt_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tt_products/1 or /tt_products/1.json
  def destroy
    @tt_product.destroy!

    respond_to do |format|
      format.html { redirect_to tt_products_path, status: :see_other, notice: "Tt product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tt_product
      @tt_product = TtProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tt_product_params
      params.require(:tt_product).permit(:name, :category_id)
    end
end
