class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @top_products = SaleItem
      .joins(:nile_product) # Join to access product details if needed
      .group(:nile_product_id)
      .select('nile_product_id, SUM(quantity_sold) AS total_sold, SUM(total) as total_amount')
      .order('total_sold DESC')
      .limit(10)

      @least_products = SaleItem
      .joins(:nile_product) # Join to access product details if needed
      .group(:nile_product_id)
      .select('nile_product_id, SUM(quantity_sold) AS total_sold, SUM(total) as total_amount')
      .order('total_sold ASC')
      .limit(10)
 
    if current_user.is_super
      render :index
    elsif current_user.role == "admin" && !current_user.is_super
      render :admin
    elsif current_user.role == "staff"
      render :staff
    end
  end
  def admin

  end

  def staff

  end
  def beer
    user_territories = current_user.employee.territories.pluck(:id)
    today      = Date.current
    start_date = today.beginning_of_week(:monday)  # This will be Monday
    end_date   = today.end_of_week(:monday)          # This will be Sunday 
    if params["territory_id"].present? && params["start"].present? && params["end"].present?
      start_date = Date.strptime(params["start"], '%d/%m/%Y')
      end_date = Date.strptime(params["end"], '%d/%m/%Y')
      territory_id = params["territory_id"]
      @top_products = NileProduct
      .joins(nile_products: { sale_items: :sale })
      .where(sales: { sale_date: start_date..end_date, territory_id: territory_id})
      .select("nile_products.*, SUM(sale_items.quantity_sold) AS total_sales")
      .group("nile_products.id")
      .order("total_sales DESC")
      .limit(10)

      @least_products = NileProduct
      .joins(nile_products: { sale_items: :sale })
      .where(sales: { sale_date: start_date..end_date, territory_id: territory_id })
      .select("nile_products.*, SUM(sale_items.quantity_sold) AS total_sales")
      .group("nile_products.id")
      .order("total_sales ASC")
      .limit(10)

      @total_sale = SaleItem
      .joins(:sale)
      .where(sales:{sale_date: start_date..end_date, territory_id: user_territories})
      .select("SUM(total) as total_sales")
      .take
    else
      @top_products = NileProduct
      .joins(sale_items: :sale )
      .where(sales: { sale_date: start_date..end_date, territory_id: user_territories})
      .select("nile_products.*, SUM(sale_items.quantity_sold) AS total_sales")
      .group("nile_products.id")
      .order("total_sales DESC")
      .limit(10)

      @least_products = NileProduct
      .joins(sale_items: :sale )
      .where(sales: { sale_date: start_date..end_date })
      .select("nile_products.*, SUM(sale_items.quantity_sold) AS total_sales")
      .group("nile_products.id")
      .order("total_sales ASC")
      .limit(10)

      @total_sale = SaleItem
      .joins(:sale)
      .where(sales:{sale_date: start_date..end_date, territory_id: user_territories})
      .select("SUM(total) as total_sales")
      .take
    end  
    
    @title = "From #{start_date.strftime('%Y-%m-%d')} to #{end_date.strftime('%Y-%m-%d')}"
    get_user_department_dashboard(params[:id])
  end
  def energy
    get_user_department_dashboard(params[:id])
  end
  def transport
    get_user_department_dashboard(params[:id])
  end
  def rentals
    get_user_department_dashboard(params[:id])
  end
  def cement
    get_user_department_dashboard(params[:id])
  end

  private
  def get_user_department_dashboard(id)
    @employee_territories = current_user.employee.employee_territories.joins(:territory).where(territories: { department_id: id })
    #if !@employee_territories.present?
      #redirect_to dashboard_path, alert: "You do not have any branches assigned to you in the department"
    #end
  end
end
