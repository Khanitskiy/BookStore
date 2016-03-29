Rails.application.routes.draw do

  get "/users/edit" => "users#settings"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", 
                                       :registrations      => "users/registrations",
                                       :sessions           => "users/sessions" }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'books#home'
  get  '/shop/search', to: 'books#search'
  resources :books, only: [:index, :show], path: '/shop'
  resources :categories, only: [:show], path: '/shop/category/'
  resources :ratings, only: [:index, :create], path: '/rating'

  scope :orders do 
    get    '/clear_shopcart', to: 'orders#clear_cookies_shopcart'
    put    '/update_shopcart_ajax', to: 'orders#update_shopcart_ajax'
    #get    '/delete_products', to: 'orders#delete_products'
  end
  resources :orders

  #scope :orders_items do 
    #delete '/delete_item/:id',    to: 'orders_items#delete_cookie_item'
  #end
  resources :orders_items

  devise_scope :user do
    get    '/settings', to: 'users#settings'
  end

  resources :order_steps
  resources :addresses, only: [:update]
  resources :users, only: [:settings, :update_data] do
    patch  '/update_data', to: 'users#update_data'
    patch  '/update_password', to: 'users#update_password'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
