class SaleEmptiesController < ApplicationController
  before_action :set_sale_empty, only: %i[ show edit update destroy ]
  before_action :set_active_link
  # GET /sale_empties or /sale_empties.json
  def index
    @territory = Territory.find(current_territory.id)
    @sale_empties = @territory.sale_empties.page(params[:page]).per(10)
  end

  # GET /sale_empties/1 or /sale_empties/1.json
  def show
  end

  # GET /sale_empties/new
  def new
    @sale_empty = SaleEmpty.new
  end

  # GET /sale_empties/1/edit
  def edit
  end

  # POST /sale_empties or /sale_empties.json
  def create
    @sale_empty = SaleEmpty.new(sale_empty_params)

    respond_to do |format|
      if @sale_empty.save
        format.html { redirect_to @sale_empty, notice: "Sale empty was successfully created." }
        format.json { render :show, status: :created, location: @sale_empty }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale_empty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale_empties/1 or /sale_empties/1.json
  def update
    respond_to do |format|
      if @sale_empty.update(sale_empty_params)
        format.html { redirect_to @sale_empty, notice: "Sale empty was successfully updated." }
        format.json { render :show, status: :ok, location: @sale_empty }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale_empty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_empties/1 or /sale_empties/1.json
  def destroy
    @sale_empty.destroy!

    respond_to do |format|
      format.html { redirect_to sale_empties_path, status: :see_other, notice: "Sale empty was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_empty
      @sale_empty = SaleEmpty.find(params[:id])
    end

    def set_active_link
      @active_link='empties inventory'
    end

    # Only allow a list of trusted parameters through.
    def sale_empty_params
      params.require(:sale_empty).permit(:sale_id, :empty_type_id, :expected, :received, :variance)
    end
end
