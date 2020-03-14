# frozen_string_literal: true

Rails.application.routes.draw do
  # get '/', to: 'welcome#index'
  resources :welcome, only: [:index], path: '/'

  # get '/register', to: 'users#new'
  resources :register, only: [:index], controller: :users, action: :new
  # post '/users', to: 'users#create'
  resources :users, only: [:create]

  # get '/login', to: 'sessions#new'
  resources 'login', only: [:index], controller: 'sessions', action: :new
  # post '/login', to: 'sessions#create'
  resources 'login', only: [:create], controller: 'sessions'
  # get '/logout', to: 'sessions#destroy'
  resources 'logout', only: [:index], controller: 'sessions', action: :destroy

  # resources :merchants, except: [:destroy]
  get '/merchants', to: 'merchants#index'
  post '/merchants', to: 'merchants#create'
  get '/merchants/new', to: 'merchants#new', as: 'new_merchant'
  get '/merchants/:id/edit', to: 'merchants#edit'
  get '/merchants/:id', to: 'merchants#show'
  patch '/merchants/:id', to: 'merchants#update'
  put '/merchants/:id', to: 'merchants#update'
  # get '/merchants/:merchant_id/items', to: 'merchant_items#index'
  resources :merchants, only: [:show] do
    resources :items, only: [:index], controller: 'merchant_items'
  end

  # resources :items, only: %i[index show] do
  #   resources :reviews, only: %i[new create]
  # end
  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show', as: 'item'
  get '/items/:item_id/reviews/new', to: 'reviews#new', as: 'new_item_review'
  post '/items/:item_id/reviews', to: 'reviews#create', as: 'item_reviews'

  # resources 'profile', only: [:index], action: :show, controller: 'profile/users', as: 'profile'
  # get 'profile', action: :edit, controller: 'profile/users', path: '/edit' as: 'profile_edit'

  namespace :profile do
    get '/', to: 'users#show'
    # resources 'users', only: [:index], path: '/', action: :show
    get '/edit', to: 'users#edit'
    # resources 'users', only: [:edit], path: '/edit', action: :edit
    patch '/user', to: 'users#update'
    # resources 'users', only: [:update], path: '/user', as: :user
    get '/edit/pw', to: 'security#edit'
    patch '/user/pw', to: 'security#update'
    resources :orders, only: [:index, :show, :new, :create, :update]
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/users/:id/orders', to: 'user_orders#index'
    get '/users/:id/orders/:id', to: 'user_orders#show'
    patch '/users/:id/orders/:id', to: 'user_orders#update'
    get '/merchants/:id/orders/:id', to: 'merchant_orders#show'
    get '/merchants/:id/items', to: 'merchant_items#index'
    get '/merchants/:id/items/new', to: 'merchant_items#new'
    post '/merchants/:id/items', to: 'merchant_items#create'
    get '/merchants/:id/items/:id', to: 'merchant_items#show'
    get '/merchants/:id/items/:id/edit', to: 'merchant_items#edit'
    patch '/merchants/:id/items/:id', to: 'merchant_items#update'
    delete '/merchants/:id/items/:id', to: 'merchant_items#destroy'
    patch '/merchants/:id/items/:id/toggle', to: 'toggle_items#update'
    resources :users, only: %i[index show]

    resources :orders, only: [:update]
    resources :merchants, only: %i[index show update]
  end

  namespace :merchant do
    get '/', to: 'dashboard#index'
    get '/:merchant_id/items/new', to: 'items#new'
    post '/:merchant_id/items', to: 'items#create'
    patch '/items/:id/toggle', to: 'toggle#update'
    resources :discounts
    resources :items, only: %i[index show edit update destroy]
    resources :orders, only: [:show]
    resources :item_orders, only: [:update]
  end

  # resources :reviews, only: [:edit, :update, :destroy]
  get 'reviews/:id/edit', to: 'reviews#edit'
  patch 'reviews/:id', to: 'reviews#update'
  delete 'reviews/:id', to: 'reviews#destroy'

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id', to: 'cart#edit'
  # resources 'cart', only: [:edit], path: 'cart/:item_id/edit'

  # resources :orders, only: [:new, :create, :show]
  get '/orders/:id', to: 'orders#show'
  get '/orders/new', to: 'orders#new'
  post '/orders', to: 'orders#create'
end
