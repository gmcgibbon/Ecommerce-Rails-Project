BrickWithButtons::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => 'shop#index', :via => :get

  match "/shop" => "shop#redirect_root", :via => :get
  match "/shop/order_placed" => "shop#place_order", :as => "order_placed", :via => :post
  match "/shop/order_placed" => "shop#order_processed", :as => "paypal_order_placed", :via => :get
  match "/shop/order/paypal" => "shop#process_paypal", :as => "process_paypal", :via => :get
  match "/shop/search" => "shop#search", :as => "search", :via => [:get, :post]
  match "/shop/checkout" => "shop#checkout", :as => "checkout", :via => :get
  match "/shop/by_platform" => "shop#shop_platform", :as => "shop_platform", :via => [:get, :post, :put]
  match "/shop/by_rating" => "shop#shop_rating", :as => "shop_rating", :via => [:get, :post]
  match "/shop/by_price" => "shop#shop_price", :as => "shop_price", :via => [:get, :post]
  match "/shop/by_date" => "shop#shop_date", :as => "shop_date", :via => [:get, :post]

  match "/games/:id" => "game#show", :as => "game", :via => :get

  match "/platforms/:id" => "platform#show", :as => "platform", :via => :get

  match "/pages/:id" => "page#show", :as => "page", :via => :get

  match "/remove_all" => "cart#remove_all", :as => "remove_all", :via => :post
  match "/remove_item" => "cart#remove_item", :as => "remove_item", :via => :post
  match "/add_item" => "cart#add_item", :as => "add_item", :via => :post
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
