Rails.application.routes.draw do
  devise_for :users
  root to: 'products#index'
  resources :carted_products
  resources :products
  get 'confirm_address' => 'users#confirm_address'
  post 'confirm_address' => 'users#update_address'
  get 'orders/new' => 'orders#new'
  get 'orders/:id' => 'orders#show'
  post 'subscriptions' => 'subscriptions#create'
  delete 'subscriptions/:id' => 'subscriptions#destroy'     
  get 'users/:id' => 'users#show'

  namespace :api do
    post 'orders' => 'orders#create'
    get '/orders/new' => 'orders#new'
    patch 'orders/:id' => 'orders#update'
  end
end