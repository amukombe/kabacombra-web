class EmptyTypesController < ApplicationController
  before_action :set_empty_type, only: %i[ show edit update destroy ]

  # GET /empty_types or /empty_types.json
  def index
    @empty_types = EmptyType.search(params).page(params[:page]).per(20)
  end

  # GET /empty_types/1 or /empty_types/1.json
  def show
  end

  # GET /empty_types/new
  def new
    @empty_type = EmptyType.new
  end

  # GET /empty_types/1/edit
  def edit
  end

  # POST /empty_types or /empty_types.json
  def create
    @empty_type = EmptyType.new(empty_type_params)

    respond_to do |format|
      if @empty_type.save
        format.html { redirect_to empty_types_path, notice: "Empty type was successfully created." }
        format.json { render :show, status: :created, location: @empty_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @empty_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /empty_types/1 or /empty_types/1.json
  def update
    respond_to do |format|
      if @empty_type.update(empty_type_params)
        format.html { redirect_to empty_types_path, notice: "Empty type was successfully updated." }
        format.json { render :show, status: :ok, location: @empty_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @empty_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empty_types/1 or /empty_types/1.json
  def destroy
    @empty_type.destroy!

    respond_to do |format|
      format.html { redirect_to empty_types_path, status: :see_other, notice: "Empty type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_empty_type
      @empty_type = EmptyType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def empty_type_params
      params.require(:empty_type).permit(:name, :recode, :price, :shell_type, :scode, :shell_price, 
      :bottle_type, :bcode, :bottle_price, :empty_number, :shell_number, :crate_size)
    end
end
