Rails.application.routes.draw do
  resources :users, except: :index 
  resources :toys

  get '/profile', to: 'users#show' # where id is current user
  root 'toys#index'
end
