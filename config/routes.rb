Rails.application.routes.draw do
  get '/', to: "welcome#index"

  resources :merchants
  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"

  resources :items, only: [:index, :show, :edit, :update]
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"

  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id", to: "cart#edit_quantity"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"

  get "/register", to: "users#new"
  post "/users", to: "users#create"

  namespace :profile do
    get "/", to: "users#show"
    get "/edit", to: "users#edit"
    resources :orders, only: [:index, :show]
    patch '/', to: "users#update"
    get "/edit/pw", to: "users#edit_pw"
    patch "/user", to: "users#update"
    patch "/user/pw", to: "security#update"
    get "/orders", to: "orders#index"
  end

  namespace :admin do
    get "/", to: "dashboard#index"
    get "/users", to: "users#index"
    get "/users/:id", to: "users#show"
    resources :merchants, only: [:index, :update]
  end

  get "/login", to: "sessions#new"
  post '/login', to: 'sessions#create'
  get "/logout", to: "sessions#destroy"

  namespace :merchant do
    get '/', to: "dashboard#index"
    get '/:id/items', to: "items#show"
    resources :items, only: [:update, :destroy]
  end
end
