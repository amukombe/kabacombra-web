class TtCategoriesController < ApplicationController
  before_action :set_tt_category, only: %i[ show edit update destroy ]

  # GET /tt_categories or /tt_categories.json
  def index
    @tt_categories = TtCategory.all
  end

  # GET /tt_categories/1 or /tt_categories/1.json
  def show
  end

  # GET /tt_categories/new
  def new
    @tt_category = TtCategory.new
  end

  # GET /tt_categories/1/edit
  def edit
  end

  # POST /tt_categories or /tt_categories.json
  def create
    @tt_category = TtCategory.new(tt_category_params)

    respond_to do |format|
      if @tt_category.save
        format.html { redirect_to @tt_category, notice: "Tt category was successfully created." }
        format.json { render :show, status: :created, location: @tt_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tt_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tt_categories/1 or /tt_categories/1.json
  def update
    respond_to do |format|
      if @tt_category.update(tt_category_params)
        format.html { redirect_to @tt_category, notice: "Tt category was successfully updated." }
        format.json { render :show, status: :ok, location: @tt_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tt_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tt_categories/1 or /tt_categories/1.json
  def destroy
    @tt_category.destroy!

    respond_to do |format|
      format.html { redirect_to tt_categories_path, status: :see_other, notice: "Tt category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tt_category
      @tt_category = TtCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tt_category_params
      params.require(:tt_category).permit(:name)
    end
end
