Rails.application.routes.draw do
  devise_for :users, controllers: {
        registrations: 'users/registrations'
      }

  root 'landing_page#index'
  get '/search_polls(.:format)' => 'landing_page#search_polls', as: 'search_polls'
  get '/news_feed_polls(.:format)' => 'landing_page#news_feed_polls', as: 'news_feed_polls'
  get '/current_user_polls(.:format)' => 'landing_page#current_user_polls', as: 'current_user_polls'
  get '/friends_pane(.:format)' => 'landing_page#friends_pane', as: 'friends_pane'
  get '/friends_for_sharing(.:format)' => 'landing_page#friends_for_sharing', as: 'friends_for_sharing'

  get '/friend_request/new' => 'friendships#new', as: 'new_friend_request'
  get '/friend_request/search_users(.:format)' => 'friendships#search_users', as: 'search_users_friend_request'
  post '/friend_request/create/:id(.:format)' => 'friendships#create', as: 'create_friend_request'
  post '/friend_request/accept/:id(.:format)' => 'friendships#accept', as: 'accept_friend_request'
  post '/friend_request/reject/:id(.:format)' => 'friendships#reject', as: 'reject_friend_request'

  get '/user_polls/:id/results(.:format)' => 'user_polls#results', as: 'user_poll_results'
  get '/user_polls/:id/poll_details(.:format)' => 'user_polls#poll_details', as: 'poll_result_details'
  get '/user_polls/:id/question_details(.:format)' => 'user_polls#question_details', as: 'question_result_details'
  post '/user_polls/:poll_id/share_with/:user_id(.:format)' => 'user_polls#share_with', as: 'share_poll_with'
  get '/user_polls/:id/vote(.:format)' => 'user_polls#vote', as: 'vote_on_poll'
  post '/user_polls/:poll_id/submit_vote(.:format)' => 'user_polls#submit_vote', as: 'submit_vote'
  get '/user_polls/:id/done(.:format)' => 'user_polls#done', as: 'finished_voting'

  get '/users/:id/profile(.:format)' => 'user_profiles#profile', as: 'view_user_profile'

  # DEPRECATED ROUTES
  get 'user_polls/news_feed_polls(.:format)' => 'user_polls#news_feed_polls'
  get 'user_polls/current_user_polls(.:format)' => 'user_polls#current_user_polls'
  resources :user_polls do
      resources :comments
      resources :results
  end
  get ':controller(/:action(/:id))'
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
