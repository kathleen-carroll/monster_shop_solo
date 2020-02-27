# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'welcome#index'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :merchants
  get '/merchants/:merchant_id/items', to: 'merchant_items#index'
  # post '/merchants/:merchant_id/items', to: 'items#create'

  resources :items, only: %i[index show edit update destroy] do
    resources :reviews, only: %i[new create]
  end

  namespace :profile do
    get '/', to: 'users#show'
    get '/edit', to: 'users#edit'
    get '/edit/pw', to: 'users#edit_pw'
    patch '/user', to: 'users#update'
    patch '/user/pw', to: 'security#update'
    resources :orders, only: [:index, :show, :new, :create, :update]
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/users/:id/orders', to: 'user_orders#index'
    get '/users/:id/orders/:id', to: 'user_orders#show'
    patch '/users/:id/orders/:id', to: 'user_orders#update'
    resources :users, only: %i[index show]
    resources :orders, only: [:update]
    resources :merchants, only: %i[index show update]
  end

  namespace :merchant do
    get '/', to: 'dashboard#index'
    get '/:merchant_id/items/new', to: 'items#new'
    post '/:merchant_id/items', to: 'items#create'
    patch '/items/:id/toggle', to: 'toggle#update'
    resources :items, only: %i[index show edit update destroy]
    resources :orders, only: [:show]
    resources :item_orders, only: [:update]
    get '/:merchant_id/coupons', to: 'coupons#index'
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id', to: 'cart#edit_quantity'

  resources :orders, only: [:new, :create, :show]
end
