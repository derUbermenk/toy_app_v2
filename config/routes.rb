Rails.application.routes.draw do
  resources :users

  resources :toys
  delete '/:id/image', to: 'toys#destroy_image', as: 'delete_image'

  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/profile', to: 'users#show' # where id is current user
  get '/dashboard', to: 'toys#index'
  root 'toys#index'
end
