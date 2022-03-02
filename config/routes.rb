Rails.application.routes.draw do
  resources :users, only: %i[show edit]

  get '/profile', to: 'users#show' # where id is current user
  root 'toys#index'
end
