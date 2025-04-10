Rails.application.routes.draw do
  resources :purchase_types
  resources :sale_empties
  resources :taxes
  resources :empty_types
  resources :bank_withdraws
  resources :bank_deposits
  resources :bank_accounts
  resources :banks
  resources :sale_items
  resources :customers
  resources :sales do
    collection do
      get "approvals"
    end
    member do
      get "sale_pdf"
    end
  end
  get "approvals/loading_order"
  get "approvals/epenses"
  get "expense_approvals",to: "expenses#approvals"
  get 'nile_products/:id/details', to: 'nile_products#details', as: :product_details
  get 'nile_products/:id/dispatchdetails', to: 'nile_products#dispatchdetails', as: :product_dispatchdetails
  get 'nile_products/:id/orderitemdetails', to: 'nile_products#orderitemdetails', as: :product_orderitemdetails
  get 'nile_products/:id/stock_details', to: 'nile_products#stock_details', as: :stock_details

  resources :expenses do
    member do
      patch :approve
      patch :acknowledge
    end
  end
  resources :expense_types
  resources :expense_categories
  resources :tt_categories
  resources :tt_products
  
  get "approvals",to: "loading_orders#approvals"
  get "expense_approvals",to: "expenses#approvals"
  resources :loading_orders do
    member do
      patch :approve
    end
  end
  resources :inventory_items do
    member do
      get :assign_store
      patch :update_store
      delete :remove_store
    end
  end
  resources :inventories do
    collection do
      get :existing_stock
      post :create_existing_stock
    end
  end
  resources :beer_dispatches do
    member do
      get "dispatch_pdf"
    end
  end
  resources :system_modules
  get "welcome/beer"
  get "welcome/transport"
  get "welcome/rentals"
  get "welcome/cement"
  get "welcome/energy"
  resources :order_drivers
  get "request", to: "requests#driver_request", as: "request"
  resources :order_items
  resources :orders  do
    member do
      get :approve_driver
      patch :update_driver_approval
      get :assign_driver
      patch :update_driver
      delete :remove_driver
      get "dispatch_pdf"
    end
  end
  resources :statuses
  resources :unit_of_measurements
  resources :nile_products do
    get 'available_stock', on: :collection
  end
  resources :nile_categories
  resources :routes
  resources :drivers
  resources :positions
  resources :trucks do
    member do
      get :assign_driver
      patch :update_driver
      delete :remove_driver
    end
  end
  resources :car_makes
  resources :truck_types
  resources :stores
  resources :territories
  resources :department_modules
  resources :employees do
    member do
      get :assign_territory
      patch :update_territory
      delete :remove_territory
    end
  end
  resources :departments
  get "users",to: "users#index"
  devise_for :users, skip: [:registrations]

  resources :users, only: [:new, :create, :edit, :update] do
    member do
      get :assign_module
      patch :update_module
      delete :remove_module
    end
  end
  #devise_for :users, controllers: {
    #registrations: 'users/registrations',
    #sessions: 'users/sessions'
  #}

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get "dashboard", to: "dashboard#index", as: "dashboard"
  get "beers", to: "dashboard#beer", as: "beers"
  get "cement", to: "dashboard#cement", as: "cement"
  get "energy", to: "dashboard#energy", as: "energy"
  get "rentals", to: "dashboard#rentals", as: "rentals"
  get "transport", to: "dashboard#transport", as: "transport"
  get "home/about"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "home#index"
end
