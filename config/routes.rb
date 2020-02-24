# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'welcome#index'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :merchants
  resources :items, only: %i[index show edit update delete]

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
    resources :users, only: %i[index show]
    resources :orders, only: [:update]
    resources :merchants, only: %i[index show update]
  end

  namespace :merchant do
    get '/', to: 'dashboard#index'
    get '/:id/items', to: 'items#show'
    resources :items, only: %i[update destroy]
  end

  get '/merchants/:merchant_id/items', to: 'items#index'
  get '/merchants/:merchant_id/items/new', to: 'items#new'
  post '/merchants/:merchant_id/items', to: 'items#create'
  delete '/items/:id', to: 'items#destroy'

  get '/items/:item_id/reviews/new', to: 'reviews#new'
  post '/items/:item_id/reviews', to: 'reviews#create'

  get '/reviews/:id/edit', to: 'reviews#edit'
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id', to: 'cart#edit_quantity'

  get '/orders/new', to: 'orders#new'
  post '/orders', to: 'orders#create'
  get '/orders/:id', to: 'orders#show'
end
