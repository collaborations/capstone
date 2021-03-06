Rails.application.routes.draw do

  devise_for :users
  resources :institutions
  
  resources :users
  resources :capacity
  
  match '/capacity/get' => 'capacity#get', via: :post
  match '/capacity/get/ids' => 'capacity#getByID', via: :post
  match '/capacity/update' => 'capacity#update', via: :post

  match '/institution/email' => 'institutions#email', via: :post

  match '/sms/info' => 'sms#info', via: :post
  match '/sms/notify' => 'sms#notify', via: :post
  match '/sms/reply' => 'sms#reply', via: :post
  match '/sms/subscribe' => 'sms#subscribe', via: :post


  get '/about' => 'about#index'

  get '/account' => 'account#index', as: 'account'

  get '/amenity/:id' => 'institutions#amenity', as: 'amenity'

  get '/institution/:id' => 'institutions#show'
  get '/institution/:id/print' => 'institutions#print', as: 'institution_print'
  
  get '/sms' => 'sms#index', as: 'mass_text'

  root "home#index"
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
