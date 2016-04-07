require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  root to: 'site#index'
  devise_for :users, controllers: {passwords: "users/passwords", sessions: "users/sessions", registrations: "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
  get '/users/index', to: 'users#index', as: "user_index"
  get '/users/edit_profile', to: 'users#edit', as: "edit_user"
  patch '/users/edit_profile', to: 'users#update', as: ""
  put '/users/edit_profile', to: 'users#update', as: ""
  resources :relationships, only: [:create]
  patch '/relationships', to: 'relationships#update', as: ""
  put '/relationships', to: 'relationships#update', as: ""
  delete '/relationships', to: 'relationships#destroy', as: ""
  
  put '/relationships/message_now', to: 'relationships#message_now', as: "relationship_message_now"
  patch '/relationships/message_now', to: 'relationships#message_now', as: ""

  put '/relationships/twitter_friends', to: 'relationships#twitter_friends', as: "twitter_friends"
  patch '/relationships/twitter_friends', to: 'relationships#twitter_friends', as: ""

  put '/relationships/user_messages', to: 'relationships#user_messages', as: "user_messages"
  patch '/relationships/user_message', to: 'relationships#user_messages', as: ""

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
