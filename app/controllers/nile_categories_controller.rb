class NileCategoriesController < ApplicationController
  before_action :set_nile_category, only: %i[ show edit update destroy ]

  # GET /nile_categories or /nile_categories.json
  def index
    @nile_categories = NileCategory.search(params).page(params[:page]).per(20)
  end

  # GET /nile_categories/1 or /nile_categories/1.json
  def show
  end

  # GET /nile_categories/new
  def new
    @nile_category = NileCategory.new
  end

  # GET /nile_categories/1/edit
  def edit
  end

  # POST /nile_categories or /nile_categories.json
  def create
    @nile_category = NileCategory.new(nile_category_params)

    respond_to do |format|
      if @nile_category.save
        format.html { redirect_to nile_categories_path, notice: "Nile category was successfully created." }
        format.json { render :show, status: :created, location: @nile_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @nile_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nile_categories/1 or /nile_categories/1.json
  def update
    respond_to do |format|
      if @nile_category.update(nile_category_params)
        format.html { redirect_to nile_categories_path, notice: "Nile category was successfully updated." }
        format.json { render :show, status: :ok, location: @nile_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @nile_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nile_categories/1 or /nile_categories/1.json
  def destroy
    @nile_category.destroy!

    respond_to do |format|
      format.html { redirect_to nile_categories_path, status: :see_other, notice: "Nile category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nile_category
      @nile_category = NileCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def nile_category_params
      params.require(:nile_category).permit(:name, :description)
    end
end
