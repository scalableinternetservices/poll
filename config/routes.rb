Rails.application.routes.draw do
  devise_for :users, controllers: {
        registrations: 'users/registrations'
      }

  root 'landing_page#index'

  get '/news_feed_polls(.:format)' => 'landing_page#news_feed_polls'
  get '/current_user_polls(.:format)' => 'landing_page#current_user_polls'

  get '/friend_request/new' => 'friendships#new', as: 'new_friend_request'
  post '/friend_request/create(.:format)' => 'friendships#create', as: 'create_friend_request'
  post '/friend_request/accept/:id(.:format)' => 'friendships#accept', as: 'accept_friend_request'
  post '/friend_request/reject/:id(.:format)' => 'friendships#reject', as: 'reject_friend_request'

  # DEPRECATED ROUTES
  get 'user_polls/news_feed_polls(.:format)' => 'user_polls#news_feed_polls'
  get 'user_polls/current_user_polls(.:format)' => 'user_polls#current_user_polls'
  resources :user_polls do
      resources :comments
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
