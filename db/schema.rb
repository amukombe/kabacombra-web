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

ActiveRecord::Schema[7.2].define(version: 2026_06_05_164923) do
  create_table "bank_accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "bank_id", null: false
    t.bigint "territory_id", null: false
    t.bigint "user_id", null: false
    t.string "account_name"
    t.string "account_number"
    t.string "branch_name"
    t.string "branch_code"
    t.string "swiftcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id"], name: "index_bank_accounts_on_bank_id"
    t.index ["territory_id"], name: "index_bank_accounts_on_territory_id"
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "bank_deposits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "bank_account_id", null: false
    t.bigint "user_id", null: false
    t.bigint "territory_id", null: false
    t.date "deposit_date"
    t.decimal "amount", precision: 10
    t.string "deposit_location"
    t.string "source_of_income"
    t.string "deposited_by"
    t.string "transaction_reference"
    t.string "additional_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_bank_deposits_on_bank_account_id"
    t.index ["territory_id"], name: "index_bank_deposits_on_territory_id"
    t.index ["user_id"], name: "index_bank_deposits_on_user_id"
  end

  create_table "bank_transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "territory_id", null: false
    t.bigint "financial_transaction_id", null: false
    t.bigint "bank_account_id", null: false
    t.string "method"
    t.string "cheque_number"
    t.decimal "amount", precision: 10
    t.date "cleared_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_type"
    t.index ["bank_account_id"], name: "index_bank_transactions_on_bank_account_id"
    t.index ["financial_transaction_id"], name: "index_bank_transactions_on_financial_transaction_id"
    t.index ["territory_id"], name: "index_bank_transactions_on_territory_id"
    t.index ["user_id"], name: "index_bank_transactions_on_user_id"
  end

  create_table "bank_transfers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "territory_id", null: false
    t.bigint "from_account_id", null: false
    t.bigint "to_account_id", null: false
    t.datetime "transfer_date"
    t.decimal "amount", precision: 10
    t.text "reason"
    t.string "transfer_ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_account_id"], name: "index_bank_transfers_on_from_account_id"
    t.index ["territory_id"], name: "index_bank_transfers_on_territory_id"
    t.index ["to_account_id"], name: "index_bank_transfers_on_to_account_id"
    t.index ["user_id"], name: "index_bank_transfers_on_user_id"
  end

  create_table "bank_withdraws", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "bank_account_id", null: false
    t.bigint "user_id", null: false
    t.bigint "territory_id", null: false
    t.date "withdraw_date"
    t.decimal "amount", precision: 10
    t.string "withdraw_location"
    t.string "reason"
    t.string "withdrawn_by"
    t.string "transaction_reference"
    t.string "additional_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_bank_withdraws_on_bank_account_id"
    t.index ["territory_id"], name: "index_bank_withdraws_on_territory_id"
    t.index ["user_id"], name: "index_bank_withdraws_on_user_id"
  end

  create_table "banks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "beer_dispatches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "fdn_number"
    t.string "truck_numberplate"
    t.string "trailer_plate"
    t.string "second_trailer"
    t.string "delivery_plant"
    t.string "shipping_point"
    t.datetime "loading_time"
    t.bigint "order_id", null: false
    t.string "dispatch_no"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "territory_id", null: false
    t.string "driver_name"
    t.string "driver_mobile"
    t.string "invoice_no"
    t.bigint "status_id"
    t.index ["order_id"], name: "index_beer_dispatches_on_order_id"
    t.index ["status_id"], name: "index_beer_dispatches_on_status_id"
    t.index ["territory_id"], name: "index_beer_dispatches_on_territory_id"
    t.index ["user_id"], name: "index_beer_dispatches_on_user_id"
  end

  create_table "beer_return_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "beer_return_id", null: false
    t.bigint "nile_product_id", null: false
    t.decimal "quantity_loaded", precision: 10
    t.decimal "quantity_returned", precision: 10
    t.decimal "holding_sale_quantity", precision: 10
    t.decimal "missing_bottles", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["beer_return_id"], name: "index_beer_return_items_on_beer_return_id"
    t.index ["nile_product_id"], name: "index_beer_return_items_on_nile_product_id"
  end

  create_table "beer_returns", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "loading_order_id", null: false
    t.datetime "return_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "territory_id", null: false
    t.index ["loading_order_id"], name: "index_beer_returns_on_loading_order_id"
    t.index ["territory_id"], name: "index_beer_returns_on_territory_id"
  end

  create_table "car_makes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cheques", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "territory_id", null: false
    t.bigint "bank_transaction_id", null: false
    t.string "cheque_number"
    t.string "payee"
    t.string "status"
    t.date "issue_date"
    t.date "cleared_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_transaction_id"], name: "index_cheques_on_bank_transaction_id"
    t.index ["territory_id"], name: "index_cheques_on_territory_id"
    t.index ["user_id"], name: "index_cheques_on_user_id"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "status_id", null: false
    t.string "description"
    t.string "comment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_comments_on_status_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "customers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "mobile"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "territory_id", null: false
    t.index ["territory_id"], name: "index_customers_on_territory_id"
  end

  create_table "department_modules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "module_url"
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_department_modules_on_department_id"
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "icon"
    t.text "app_icon"
    t.string "app_url"
  end

  create_table "destinations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "nile_product_id", null: false
    t.decimal "selling_price", precision: 10
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nile_product_id"], name: "index_destinations_on_nile_product_id"
  end

  create_table "dispatch_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "quantity_dispatched", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "beer_dispatch_id", null: false
    t.decimal "quantity_ordered", precision: 10
    t.bigint "order_item_id", null: false
    t.index ["beer_dispatch_id"], name: "index_dispatch_items_on_beer_dispatch_id"
    t.index ["order_item_id"], name: "index_dispatch_items_on_order_item_id"
  end

  create_table "drivers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
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

  create_table "employee_departments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_employee_departments_on_department_id"
    t.index ["employee_id"], name: "index_employee_departments_on_employee_id"
  end

  create_table "employee_territories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "territory_id", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_territories_on_employee_id"
    t.index ["territory_id"], name: "index_employee_territories_on_territory_id"
  end

  create_table "employees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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
    t.bigint "position_id", null: false
    t.index ["position_id"], name: "index_employees_on_position_id"
  end

  create_table "empty_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "bottle_price", precision: 10
    t.integer "empty_number"
    t.string "rcode"
    t.string "shell_type"
    t.string "scode"
    t.decimal "shell_price", precision: 10
    t.string "bottle_type"
    t.string "bcode"
    t.integer "shell_number"
    t.integer "crate_size"
  end

  create_table "expense_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expense_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "expense_category_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_category_id"], name: "index_expense_types_on_expense_category_id"
  end

  create_table "expenses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "expense_type_id", null: false
    t.bigint "user_id", null: false
    t.bigint "territory_id", null: false
    t.bigint "status_id", null: false
    t.string "expense_title"
    t.integer "received_by"
    t.integer "authorized_by"
    t.string "description"
    t.date "expense_date"
    t.decimal "amount", precision: 10
    t.string "source_of_income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id"
    t.index ["status_id"], name: "index_expenses_on_status_id"
    t.index ["territory_id"], name: "index_expenses_on_territory_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "financial_transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "territory_id", null: false
    t.string "transaction_type"
    t.decimal "amount", precision: 10
    t.date "transaction_date"
    t.string "reference"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["territory_id"], name: "index_financial_transactions_on_territory_id"
    t.index ["user_id"], name: "index_financial_transactions_on_user_id"
  end

  create_table "inventories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "total", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.datetime "delivery_time"
    t.bigint "territory_id", null: false
    t.bigint "beer_dispatch_id"
    t.bigint "warehouse_id"
    t.bigint "status_id"
    t.index ["beer_dispatch_id"], name: "index_inventories_on_beer_dispatch_id"
    t.index ["status_id"], name: "index_inventories_on_status_id"
    t.index ["territory_id"], name: "index_inventories_on_territory_id"
    t.index ["user_id"], name: "index_inventories_on_user_id"
    t.index ["warehouse_id"], name: "index_inventories_on_warehouse_id"
  end

  create_table "inventory_item_stores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "inventory_item_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_item_id"], name: "index_inventory_item_stores_on_inventory_item_id"
    t.index ["store_id"], name: "index_inventory_item_stores_on_store_id"
  end

  create_table "inventory_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.decimal "quantity_ordered", precision: 10
    t.decimal "quantity_dispatched", precision: 10
    t.decimal "quantity_received", precision: 10
    t.decimal "quantity_sold", precision: 10, default: "0"
    t.decimal "purchase_price", precision: 10
    t.decimal "selling_price", precision: 10
    t.boolean "is_active", default: false
    t.boolean "is_closed", default: false
    t.boolean "is_deleted", default: false
    t.date "manufacture_date"
    t.date "expiry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stock_no"
    t.decimal "breakages", precision: 10
    t.decimal "missing_bottles", precision: 10
    t.decimal "complaints", precision: 10
    t.decimal "remaining_quantity", precision: 10, default: "0"
    t.decimal "returns", precision: 10, default: "0"
    t.decimal "transfers", precision: 10, default: "0"
    t.decimal "nbl_return", precision: 10, default: "0"
    t.bigint "nile_product_id"
    t.bigint "dispatch_item_id"
    t.decimal "bad_beer", precision: 10
    t.decimal "good_beer", precision: 10
    t.index ["dispatch_item_id"], name: "index_inventory_items_on_dispatch_item_id"
    t.index ["inventory_id"], name: "index_inventory_items_on_inventory_id"
    t.index ["nile_product_id"], name: "index_inventory_items_on_nile_product_id"
  end

  create_table "inventory_transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "transaction_date"
    t.decimal "transaction_quantity", precision: 10
    t.string "transaction_type"
    t.string "direction"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "nile_product_id", null: false
    t.bigint "territory_id"
    t.index ["nile_product_id"], name: "index_inventory_transactions_on_nile_product_id"
    t.index ["territory_id"], name: "index_inventory_transactions_on_territory_id"
  end

  create_table "loading_order_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "loading_order_id", null: false
    t.decimal "quantity_loaded", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "nile_product_id", null: false
    t.decimal "remaining_quantity", precision: 10
    t.index ["loading_order_id"], name: "index_loading_order_items_on_loading_order_id"
    t.index ["nile_product_id"], name: "index_loading_order_items_on_nile_product_id"
  end

  create_table "loading_orders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "territory_id", null: false
    t.string "vehicle_numperplate"
    t.string "destination"
    t.datetime "loading_date"
    t.string "order_number"
    t.integer "sales_man"
    t.integer "authorized_by"
    t.integer "verified_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "status_id", null: false
    t.string "driver_name"
    t.bigint "store_id"
    t.index ["status_id"], name: "index_loading_orders_on_status_id"
    t.index ["store_id"], name: "index_loading_orders_on_store_id"
    t.index ["territory_id"], name: "index_loading_orders_on_territory_id"
    t.index ["user_id"], name: "index_loading_orders_on_user_id"
  end

  create_table "nile_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nile_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "crate_size"
    t.string "bottle_size"
    t.string "pcode"
    t.bigint "nile_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "buying_price"
    t.string "selling_price"
    t.bigint "empty_type_id"
    t.integer "product_number"
    t.index ["empty_type_id"], name: "index_nile_products_on_empty_type_id"
    t.index ["nile_category_id"], name: "index_nile_products_on_nile_category_id"
  end

  create_table "order_drivers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "driver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_order_drivers_on_driver_id"
    t.index ["order_id"], name: "index_order_drivers_on_order_id"
  end

  create_table "order_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "nile_product_id", null: false
    t.decimal "quantity", precision: 10
    t.decimal "unit_price", precision: 10
    t.decimal "total", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "unit_of_measurement_id", null: false
    t.index ["nile_product_id"], name: "index_order_items_on_nile_product_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["unit_of_measurement_id"], name: "index_order_items_on_unit_of_measurement_id"
  end

  create_table "order_routes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "route_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_routes_on_order_id"
    t.index ["route_id"], name: "index_order_routes_on_route_id"
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "order_number"
    t.date "order_date"
    t.bigint "user_id", null: false
    t.bigint "status_id", null: false
    t.decimal "total_price", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "departure_date"
    t.string "description"
    t.bigint "territory_id", null: false
    t.index ["status_id"], name: "index_orders_on_status_id"
    t.index ["territory_id"], name: "index_orders_on_territory_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payment_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "territory_id", null: false
    t.bigint "user_id", null: false
    t.bigint "bank_account_id", null: false
    t.decimal "amount", precision: 10
    t.datetime "payment_date"
    t.string "payment_ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_no"
    t.integer "payment_method"
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.index ["bank_account_id"], name: "index_payments_on_bank_account_id"
    t.index ["recipient_type", "recipient_id"], name: "index_payments_on_recipient_type_and_recipient_id"
    t.index ["territory_id"], name: "index_payments_on_territory_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "positions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "start_location"
    t.string "end_location"
    t.decimal "distance", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sale_empties", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "sale_id", null: false
    t.bigint "empty_type_id", null: false
    t.integer "expected"
    t.integer "received"
    t.integer "variance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["empty_type_id"], name: "index_sale_empties_on_empty_type_id"
    t.index ["sale_id"], name: "index_sale_empties_on_sale_id"
  end

  create_table "sale_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "quantity_sold", precision: 10
    t.decimal "amount", precision: 10
    t.decimal "total", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "empties_returned"
    t.decimal "cash_for_empties", precision: 10
    t.bigint "sale_id", null: false
    t.bigint "purchase_type_id"
    t.bigint "nile_product_id", null: false
    t.index ["nile_product_id"], name: "index_sale_items_on_nile_product_id"
    t.index ["purchase_type_id"], name: "index_sale_items_on_purchase_type_id"
    t.index ["sale_id"], name: "index_sale_items_on_sale_id"
  end

  create_table "sale_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "mode_of_payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "receipt_no"
    t.bigint "territory_id", null: false
    t.integer "verified_by"
    t.datetime "sale_date"
    t.string "customer_name"
    t.string "tin"
    t.string "payment_ref"
    t.bigint "status_id", null: false
    t.string "sales_route"
    t.string "customer_mobile"
    t.text "notes"
    t.decimal "vat", precision: 10
    t.bigint "store_id", null: false
    t.index ["status_id"], name: "index_sales_on_status_id"
    t.index ["store_id"], name: "index_sales_on_store_id"
    t.index ["territory_id"], name: "index_sales_on_territory_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "statuses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_adjustments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "nile_product_id", null: false
    t.bigint "territory_id", null: false
    t.bigint "user_id", null: false
    t.decimal "quantity", precision: 10
    t.string "direction"
    t.string "movement_type"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nile_product_id"], name: "index_stock_adjustments_on_nile_product_id"
    t.index ["territory_id"], name: "index_stock_adjustments_on_territory_id"
    t.index ["user_id"], name: "index_stock_adjustments_on_user_id"
  end

  create_table "stock_stores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "inventory_item_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_item_id"], name: "index_stock_stores_on_inventory_item_id"
    t.index ["store_id"], name: "index_stock_stores_on_store_id"
  end

  create_table "stock_transfer_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "nile_product_id", null: false
    t.bigint "stock_transfer_id", null: false
    t.decimal "transfer_quantity", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "quantity_received", precision: 10
    t.decimal "breakages", precision: 10
    t.decimal "complaints", precision: 10
    t.index ["nile_product_id"], name: "index_stock_transfer_items_on_nile_product_id"
    t.index ["stock_transfer_id"], name: "index_stock_transfer_items_on_stock_transfer_id"
  end

  create_table "stock_transfers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "transfer_type"
    t.integer "source_id"
    t.integer "destination_id"
    t.date "transfer_date"
    t.string "description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "territory_id", null: false
    t.string "from_distributor"
    t.string "to_distributor"
    t.string "numberplate"
    t.string "driver_details"
    t.bigint "user_id"
    t.text "rejection_reason"
    t.bigint "received_by"
    t.datetime "received_at"
    t.boolean "inventory_transactions_created", default: false
    t.index ["territory_id"], name: "index_stock_transfers_on_territory_id"
    t.index ["user_id"], name: "index_stock_transfers_on_user_id"
  end

  create_table "store_transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "nile_product_id", null: false
    t.bigint "territory_id", null: false
    t.bigint "user_id", null: false
    t.decimal "quantity", precision: 10
    t.string "direction"
    t.string "movement_type"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id", null: false
    t.datetime "transaction_date"
    t.index ["nile_product_id"], name: "index_store_transactions_on_nile_product_id"
    t.index ["store_id"], name: "index_store_transactions_on_store_id"
    t.index ["territory_id"], name: "index_store_transactions_on_territory_id"
    t.index ["user_id"], name: "index_store_transactions_on_user_id"
  end

  create_table "stores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "territory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["territory_id"], name: "index_stores_on_territory_id"
  end

  create_table "suppliers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "mobile"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_modules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "module_url"
    t.string "icon"
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_system_modules_on_department_id"
  end

  create_table "taxes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.decimal "tax_percentage", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "territories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "telephone"
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_territories_on_department_id"
  end

  create_table "truck_drivers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "truck_id", null: false
    t.bigint "driver_id", null: false
    t.string "date_assigned"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_truck_drivers_on_driver_id"
    t.index ["truck_id"], name: "index_truck_drivers_on_truck_id"
    t.index ["user_id"], name: "index_truck_drivers_on_user_id"
  end

  create_table "truck_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trucks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "plate_number"
    t.string "model"
    t.string "chasis"
    t.string "status"
    t.bigint "car_make_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "truck_type_id", null: false
    t.index ["car_make_id"], name: "index_trucks_on_car_make_id"
    t.index ["truck_type_id"], name: "index_trucks_on_truck_type_id"
  end

  create_table "tt_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unit_of_measurements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_modules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "system_module_id", null: false
    t.bigint "user_id", null: false
    t.bigint "territory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_module_id"], name: "index_user_modules_on_system_module_id"
    t.index ["territory_id"], name: "index_user_modules_on_territory_id"
    t.index ["user_id"], name: "index_user_modules_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id", null: false
    t.integer "role"
    t.boolean "is_super"
    t.bigint "store_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["store_id"], name: "index_users_on_store_id"
  end

  create_table "vendor_adjustiment_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "vendor_adjustiment_id", null: false
    t.bigint "nile_product_id", null: false
    t.decimal "quantity", precision: 10
    t.decimal "quantity_sold", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nile_product_id"], name: "index_vendor_adjustiment_items_on_nile_product_id"
    t.index ["vendor_adjustiment_id"], name: "index_vendor_adjustiment_items_on_vendor_adjustiment_id"
  end

  create_table "vendor_adjustiments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "purchase_type_id", null: false
    t.date "adjustment_date"
    t.bigint "territory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "journal_no"
    t.string "ref_no"
    t.index ["purchase_type_id"], name: "index_vendor_adjustiments_on_purchase_type_id"
    t.index ["territory_id"], name: "index_vendor_adjustiments_on_territory_id"
    t.index ["user_id"], name: "index_vendor_adjustiments_on_user_id"
  end

  create_table "vendor_payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "territory_id", null: false
    t.bigint "user_id", null: false
    t.date "payment_date"
    t.string "journal_no"
    t.string "ref_no"
    t.decimal "payments", precision: 10
    t.decimal "suspence", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["territory_id"], name: "index_vendor_payments_on_territory_id"
    t.index ["user_id"], name: "index_vendor_payments_on_user_id"
  end

  create_table "warehouses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "territory_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["territory_id"], name: "index_warehouses_on_territory_id"
  end

  add_foreign_key "bank_accounts", "banks"
  add_foreign_key "bank_accounts", "territories"
  add_foreign_key "bank_accounts", "users"
  add_foreign_key "bank_deposits", "bank_accounts"
  add_foreign_key "bank_deposits", "territories"
  add_foreign_key "bank_deposits", "users"
  add_foreign_key "bank_transactions", "bank_accounts"
  add_foreign_key "bank_transactions", "financial_transactions"
  add_foreign_key "bank_transactions", "territories"
  add_foreign_key "bank_transactions", "users"
  add_foreign_key "bank_transfers", "bank_accounts", column: "from_account_id"
  add_foreign_key "bank_transfers", "bank_accounts", column: "to_account_id"
  add_foreign_key "bank_transfers", "territories"
  add_foreign_key "bank_transfers", "users"
  add_foreign_key "bank_withdraws", "bank_accounts"
  add_foreign_key "bank_withdraws", "territories"
  add_foreign_key "bank_withdraws", "users"
  add_foreign_key "beer_dispatches", "orders"
  add_foreign_key "beer_dispatches", "statuses"
  add_foreign_key "beer_dispatches", "territories"
  add_foreign_key "beer_dispatches", "users"
  add_foreign_key "beer_return_items", "beer_returns"
  add_foreign_key "beer_return_items", "nile_products"
  add_foreign_key "beer_returns", "loading_orders"
  add_foreign_key "beer_returns", "territories"
  add_foreign_key "cheques", "bank_transactions"
  add_foreign_key "cheques", "territories"
  add_foreign_key "cheques", "users"
  add_foreign_key "comments", "statuses"
  add_foreign_key "comments", "users"
  add_foreign_key "customers", "territories"
  add_foreign_key "department_modules", "departments"
  add_foreign_key "destinations", "nile_products"
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
  add_foreign_key "financial_transactions", "territories"
  add_foreign_key "financial_transactions", "users"
  add_foreign_key "inventories", "beer_dispatches"
  add_foreign_key "inventories", "statuses"
  add_foreign_key "inventories", "territories"
  add_foreign_key "inventories", "users"
  add_foreign_key "inventories", "warehouses"
  add_foreign_key "inventory_item_stores", "inventory_items"
  add_foreign_key "inventory_item_stores", "stores"
  add_foreign_key "inventory_items", "dispatch_items"
  add_foreign_key "inventory_items", "inventories"
  add_foreign_key "inventory_items", "nile_products"
  add_foreign_key "inventory_transactions", "nile_products"
  add_foreign_key "inventory_transactions", "territories"
  add_foreign_key "loading_order_items", "loading_orders"
  add_foreign_key "loading_order_items", "nile_products"
  add_foreign_key "loading_orders", "statuses"
  add_foreign_key "loading_orders", "stores"
  add_foreign_key "loading_orders", "territories"
  add_foreign_key "loading_orders", "users"
  add_foreign_key "nile_products", "empty_types"
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
  add_foreign_key "payments", "bank_accounts"
  add_foreign_key "payments", "territories"
  add_foreign_key "payments", "users"
  add_foreign_key "sale_empties", "empty_types"
  add_foreign_key "sale_empties", "sales"
  add_foreign_key "sale_items", "nile_products"
  add_foreign_key "sale_items", "purchase_types"
  add_foreign_key "sale_items", "sales"
  add_foreign_key "sales", "statuses"
  add_foreign_key "sales", "stores"
  add_foreign_key "sales", "territories"
  add_foreign_key "sales", "users"
  add_foreign_key "stock_adjustments", "nile_products"
  add_foreign_key "stock_adjustments", "territories"
  add_foreign_key "stock_adjustments", "users"
  add_foreign_key "stock_stores", "inventory_items"
  add_foreign_key "stock_stores", "stores"
  add_foreign_key "stock_transfer_items", "nile_products"
  add_foreign_key "stock_transfer_items", "stock_transfers"
  add_foreign_key "stock_transfers", "territories"
  add_foreign_key "stock_transfers", "users"
  add_foreign_key "store_transactions", "nile_products"
  add_foreign_key "store_transactions", "stores"
  add_foreign_key "store_transactions", "territories"
  add_foreign_key "store_transactions", "users"
  add_foreign_key "stores", "territories"
  add_foreign_key "system_modules", "departments"
  add_foreign_key "territories", "departments"
  add_foreign_key "truck_drivers", "drivers"
  add_foreign_key "truck_drivers", "trucks"
  add_foreign_key "truck_drivers", "users"
  add_foreign_key "trucks", "car_makes"
  add_foreign_key "trucks", "truck_types"
  add_foreign_key "user_modules", "system_modules"
  add_foreign_key "user_modules", "territories"
  add_foreign_key "user_modules", "users"
  add_foreign_key "users", "employees"
  add_foreign_key "users", "stores"
  add_foreign_key "vendor_adjustiment_items", "nile_products"
  add_foreign_key "vendor_adjustiment_items", "vendor_adjustiments"
  add_foreign_key "vendor_adjustiments", "purchase_types"
  add_foreign_key "vendor_adjustiments", "territories"
  add_foreign_key "vendor_adjustiments", "users"
  add_foreign_key "vendor_payments", "territories"
  add_foreign_key "vendor_payments", "users"
  add_foreign_key "warehouses", "territories"
end
