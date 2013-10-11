SnapPea::Application.routes.draw do

  # Application Root
  root :to => "homepage#index"

  get "/search.html", :to => "search#index"

  # Global Resources
  resources :homepage
  resources :pricing_tiers
  resources :accounts do
    get 'export_events', :on => :member
    get 'export_billing_references', :on => :member
    resources :contacts, except: [:index]
    resources :locations, except: [:index]
    resources :billing_references
    resources :preferences, except: [:index]
    resources :issues
  end
  resources :issues do
    get 'toggle', on: :member
    resources :comments, only: [:create]
  end

  resources :menu_level_discounts, :except => [ :index, :show ]

  # User resources
  resources :profiles

  # Event resources
  resources :events do
    post 'update_transaction_method', :on => :member
    post 'duplicate_event', :on => :member
    get 'generate', :on => :member
    get 'reload_site_notes', on: :member
    
    resources :event_vendors do
      post 'change_grouped_menu_template_selections', :on => :member
    end
    resources :line_items do
      get 'new_menu_item', :on => :new
    end
    resources :billing_references
    resources :issues
  end

  resources :billing_references  do
    get 'get_choices'
  end

  # Vendor resources
  resources :vendors do
    get 'get_vendors_by_cuisine_and_product', :on => :collection
    get 'get_vendor_menu_templates_by_product', :on => :member
    get 'export_events', :on => :member
    resources :contacts, except: [:index]
    resources :inventory_items
    resources :menu_templates do
      post 'change_inventory_items', :on => :member
      post 'create_menu_group', :on => :member
      post 'delete_menu_group', :on => :member
    end
    resources :issues
  end

  resources :menus do
    resources :menu_items, :except => :index
  end

  namespace :admin do
    root :to => 'dashboard#index'

    resources :emails, except: [:index, :show]
    resources :managed_services_reports
    resources :general_reports
    resources :users
    resources :account_pricing_tiers
    resources :markets, except: [:index]
    resources :buildings, except: [:index] do
      get 'new_with_account', :on => :new
      resources :asset
    end

    # Action Mailer Testing
    match 'mailer(/:action(/:id(.:format)))' => 'mailer#:action'
  end

  # Devise (User routes)
  devise_for :users, :controllers => {:registrations => "users/registrations", :passwords => "users/passwords"}

  devise_scope :user do
    # get 'register', :to => 'devise/registrations#new', :as => 'register'
    get 'login', :to => 'devise/sessions#new', :as => 'login'
    get 'logout', :to => 'devise/sessions#destroy', :as => 'logout'        
  end

  #Resque Monitor
  mount Resque::Server, :at => "/resque"

end
