# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_12_20_131717) do
  create_table "beer_dispatches", force: :cascade do |t|
    t.string "fdn_number"
    t.string "truck_numberplate"
    t.string "trailer_plate"
    t.string "second_trailer"
    t.string "delivery_plant"
    t.string "shipping_point"
    t.datetime "loading_time"
    t.integer "order_id", null: false
    t.string "dispatch_no"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "territory_id", null: false
    t.string "driver_name"
    t.string "driver_mobile"
    t.index ["order_id"], name: "index_beer_dispatches_on_order_id"
    t.index ["territory_id"], name: "index_beer_dispatches_on_territory_id"
    t.index ["user_id"], name: "index_beer_dispatches_on_user_id"
  end

  create_table "car_makes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "status_id", null: false
    t.string "description"
    t.string "comment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_comments_on_status_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "mobile"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "territory_id", null: false
    t.index ["territory_id"], name: "index_customers_on_territory_id"
  end

  create_table "department_modules", force: :cascade do |t|
    t.string "name"
    t.string "module_url"
    t.integer "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_department_modules_on_department_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon"
    t.string "app_icon"
    t.string "app_url"
  end

  create_table "dispatch_items", force: :cascade do |t|
    t.decimal "quantity_dispatched"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "beer_dispatch_id", null: false
    t.decimal "quantity_ordered"
    t.integer "order_item_id", null: false
    t.index ["beer_dispatch_id"], name: "index_dispatch_items_on_beer_dispatch_id"
    t.index ["order_item_id"], name: "index_dispatch_items_on_order_item_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.string "license_number"
    t.date "issued_date"
    t.date "expiry_date"
    t.string "license_class"
    t.string "issued_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_available"
    t.index ["employee_id"], name: "index_drivers_on_employee_id"
  end

  create_table "employee_departments", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_employee_departments_on_department_id"
    t.index ["employee_id"], name: "index_employee_departments_on_employee_id"
  end

  create_table "employee_territories", force: :cascade do |t|
    t.integer "territory_id", null: false
    t.integer "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_territories_on_employee_id"
    t.index ["territory_id"], name: "index_employee_territories_on_territory_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "firstname"
    t.string "middlename"
    t.string "lastname"
    t.string "email"
    t.string "mobile"
    t.date "dob"
    t.string "address"
    t.string "nssf"
    t.string "tin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position_id", null: false
    t.index ["position_id"], name: "index_employees_on_position_id"
  end

  create_table "expense_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expense_types", force: :cascade do |t|
    t.integer "expense_category_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_category_id"], name: "index_expense_types_on_expense_category_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "expense_type_id", null: false
    t.integer "user_id", null: false
    t.integer "territory_id", null: false
    t.integer "status_id", null: false
    t.string "expense_title"
    t.integer "received_by"
    t.integer "authorized_by"
    t.string "description"
    t.date "expense_date"
    t.decimal "amount"
    t.string "source_of_income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id"
    t.index ["status_id"], name: "index_expenses_on_status_id"
    t.index ["territory_id"], name: "index_expenses_on_territory_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "beer_dispatch_id", null: false
    t.integer "user_id", null: false
    t.datetime "delivery_time"
    t.integer "territory_id", null: false
    t.index ["beer_dispatch_id"], name: "index_inventories_on_beer_dispatch_id"
    t.index ["territory_id"], name: "index_inventories_on_territory_id"
    t.index ["user_id"], name: "index_inventories_on_user_id"
  end

  create_table "inventory_item_stores", force: :cascade do |t|
    t.integer "inventory_item_id", null: false
    t.integer "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_item_id"], name: "index_inventory_item_stores_on_inventory_item_id"
    t.index ["store_id"], name: "index_inventory_item_stores_on_store_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.integer "inventory_id", null: false
    t.decimal "quantity_ordered"
    t.decimal "quantity_dispatched"
    t.decimal "quantity_received"
    t.decimal "quantity_sold"
    t.decimal "purchase_price"
    t.decimal "selling_price"
    t.boolean "is_active", default: false
    t.boolean "is_closed", default: false
    t.boolean "is_deleted", default: false
    t.date "manufacture_date"
    t.date "expiry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stock_no"
    t.integer "dispatch_item_id", null: false
    t.decimal "breakages"
    t.decimal "missing_bottles"
    t.decimal "complaints"
    t.index ["dispatch_item_id"], name: "index_inventory_items_on_dispatch_item_id"
    t.index ["inventory_id"], name: "index_inventory_items_on_inventory_id"
  end

  create_table "loading_order_items", force: :cascade do |t|
    t.integer "loading_order_id", null: false
    t.decimal "quantity_loaded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nile_product_id", null: false
    t.index ["loading_order_id"], name: "index_loading_order_items_on_loading_order_id"
    t.index ["nile_product_id"], name: "index_loading_order_items_on_nile_product_id"
  end

  create_table "loading_orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "territory_id", null: false
    t.string "vehicle_numperplate"
    t.string "destination"
    t.datetime "loading_date"
    t.string "order_number"
    t.integer "sales_man"
    t.integer "authorized_by"
    t.integer "verified_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_id", null: false
    t.string "driver_name"
    t.integer "sale_type_id", null: false
    t.index ["sale_type_id"], name: "index_loading_orders_on_sale_type_id"
    t.index ["status_id"], name: "index_loading_orders_on_status_id"
    t.index ["territory_id"], name: "index_loading_orders_on_territory_id"
    t.index ["user_id"], name: "index_loading_orders_on_user_id"
  end

  create_table "nile_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nile_products", force: :cascade do |t|
    t.string "name"
    t.integer "crate_size"
    t.string "bottle_size"
    t.string "pcode"
    t.integer "nile_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "buying_price"
    t.string "selling_price"
    t.string "empty_type"
    t.decimal "empty_price"
    t.index ["nile_category_id"], name: "index_nile_products_on_nile_category_id"
  end

  create_table "order_drivers", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "driver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_order_drivers_on_driver_id"
    t.index ["order_id"], name: "index_order_drivers_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.decimal "quantity"
    t.decimal "unit_price"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nile_product_id", null: false
    t.integer "unit_of_measurement_id", null: false
    t.index ["nile_product_id"], name: "index_order_items_on_nile_product_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["unit_of_measurement_id"], name: "index_order_items_on_unit_of_measurement_id"
  end

  create_table "order_routes", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "route_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_routes_on_order_id"
    t.index ["route_id"], name: "index_order_routes_on_route_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_number"
    t.date "order_date"
    t.integer "user_id", null: false
    t.integer "status_id", null: false
    t.decimal "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "departure_date"
    t.string "description"
    t.integer "territory_id", null: false
    t.index ["status_id"], name: "index_orders_on_status_id"
    t.index ["territory_id"], name: "index_orders_on_territory_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routes", force: :cascade do |t|
    t.string "name"
    t.string "start_location"
    t.string "end_location"
    t.decimal "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sale_items", force: :cascade do |t|
    t.integer "loading_order_item_id", null: false
    t.decimal "quantity_sold"
    t.decimal "amount"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "empties_returned"
    t.decimal "cash_for_empties"
    t.integer "sale_id", null: false
    t.index ["loading_order_item_id"], name: "index_sale_items_on_loading_order_item_id"
    t.index ["sale_id"], name: "index_sale_items_on_sale_id"
  end

  create_table "sale_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "user_id", null: false
    t.string "sale_type"
    t.string "mode_of_payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "receipt_no"
    t.integer "territory_id", null: false
    t.integer "verified_by"
    t.index ["customer_id"], name: "index_sales_on_customer_id"
    t.index ["territory_id"], name: "index_sales_on_territory_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_stores", force: :cascade do |t|
    t.integer "inventory_item_id", null: false
    t.integer "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_item_id"], name: "index_stock_stores_on_inventory_item_id"
    t.index ["store_id"], name: "index_stock_stores_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "territory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["territory_id"], name: "index_stores_on_territory_id"
  end

  create_table "system_modules", force: :cascade do |t|
    t.string "name"
    t.string "module_url"
    t.string "icon"
    t.integer "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_system_modules_on_department_id"
  end

  create_table "territories", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "telephone"
    t.integer "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_territories_on_department_id"
  end

  create_table "truck_drivers", force: :cascade do |t|
    t.integer "truck_id", null: false
    t.integer "driver_id", null: false
    t.string "date_assigned"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_truck_drivers_on_driver_id"
    t.index ["truck_id"], name: "index_truck_drivers_on_truck_id"
    t.index ["user_id"], name: "index_truck_drivers_on_user_id"
  end

  create_table "truck_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trucks", force: :cascade do |t|
    t.string "plate_number"
    t.string "model"
    t.string "chasis"
    t.string "status"
    t.integer "car_make_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "truck_type_id", null: false
    t.index ["car_make_id"], name: "index_trucks_on_car_make_id"
    t.index ["truck_type_id"], name: "index_trucks_on_truck_type_id"
  end

  create_table "tt_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tt_products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tt_category_id", null: false
    t.index ["tt_category_id"], name: "index_tt_products_on_tt_category_id"
  end

  create_table "unit_of_measurements", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_modules", force: :cascade do |t|
    t.integer "system_module_id", null: false
    t.integer "user_id", null: false
    t.integer "territory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_module_id"], name: "index_user_modules_on_system_module_id"
    t.index ["territory_id"], name: "index_user_modules_on_territory_id"
    t.index ["user_id"], name: "index_user_modules_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id", null: false
    t.integer "role"
    t.boolean "is_super"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "beer_dispatches", "orders"
  add_foreign_key "beer_dispatches", "territories"
  add_foreign_key "beer_dispatches", "users"
  add_foreign_key "comments", "statuses"
  add_foreign_key "comments", "users"
  add_foreign_key "customers", "territories"
  add_foreign_key "department_modules", "departments"
  add_foreign_key "dispatch_items", "beer_dispatches"
  add_foreign_key "dispatch_items", "order_items"
  add_foreign_key "drivers", "employees"
  add_foreign_key "employee_departments", "departments"
  add_foreign_key "employee_departments", "employees"
  add_foreign_key "employee_territories", "employees"
  add_foreign_key "employee_territories", "territories"
  add_foreign_key "employees", "positions"
  add_foreign_key "expense_types", "expense_categories"
  add_foreign_key "expenses", "expense_types"
  add_foreign_key "expenses", "statuses"
  add_foreign_key "expenses", "territories"
  add_foreign_key "expenses", "users"
  add_foreign_key "inventories", "beer_dispatches"
  add_foreign_key "inventories", "territories"
  add_foreign_key "inventories", "users"
  add_foreign_key "inventory_item_stores", "inventory_items"
  add_foreign_key "inventory_item_stores", "stores"
  add_foreign_key "inventory_items", "dispatch_items"
  add_foreign_key "inventory_items", "inventories"
  add_foreign_key "loading_order_items", "loading_orders"
  add_foreign_key "loading_order_items", "nile_products"
  add_foreign_key "loading_orders", "sale_types"
  add_foreign_key "loading_orders", "statuses"
  add_foreign_key "loading_orders", "territories"
  add_foreign_key "loading_orders", "users"
  add_foreign_key "nile_products", "nile_categories"
  add_foreign_key "order_drivers", "drivers"
  add_foreign_key "order_drivers", "orders"
  add_foreign_key "order_items", "nile_products"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "unit_of_measurements"
  add_foreign_key "order_routes", "orders"
  add_foreign_key "order_routes", "routes"
  add_foreign_key "orders", "statuses"
  add_foreign_key "orders", "territories"
  add_foreign_key "orders", "users"
  add_foreign_key "sale_items", "loading_order_items"
  add_foreign_key "sale_items", "sales"
  add_foreign_key "sales", "customers"
  add_foreign_key "sales", "territories"
  add_foreign_key "sales", "users"
  add_foreign_key "stock_stores", "inventory_items"
  add_foreign_key "stock_stores", "stores"
  add_foreign_key "stores", "territories"
  add_foreign_key "system_modules", "departments"
  add_foreign_key "territories", "departments"
  add_foreign_key "truck_drivers", "drivers"
  add_foreign_key "truck_drivers", "trucks"
  add_foreign_key "truck_drivers", "users"
  add_foreign_key "trucks", "car_makes"
  add_foreign_key "trucks", "truck_types"
  add_foreign_key "tt_products", "tt_categories"
  add_foreign_key "user_modules", "system_modules"
  add_foreign_key "user_modules", "territories"
  add_foreign_key "user_modules", "users"
  add_foreign_key "users", "employees"
end
