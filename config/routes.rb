Rails.application.routes.draw do

  post 'addresses/edit/:id', to: 'addresses#edit', as: 'address_edit'
  delete 'addresses/:id', to: 'addresses#destroy', as: 'address'
  post 'addresses/', to: 'addresses#create', as: 'address_new'

  get 'categories/:id', to: 'categories#show', as: 'category'
  get 'categories',     to: 'categories#index'

  get 'checkout/shipment', to: 'checkout#shipment'
  get 'checkout/payment', to: 'checkout#payment'
  get 'checkout/address', to: 'checkout#address'
  get 'checkout/review', to: 'checkout#review'

  patch 'cart/add', to: 'cart#add'
  patch 'cart/remove', to: 'cart#remove'
  patch 'cart/update', to: 'cart#update'
  get   'cart/',    to: 'cart#show', as: 'cart'

  get 'products/:id', to: 'products#show', as: 'product'
  get 'products',     to: 'products#index'

  resources :sessions, only: [:new, :create, :destroy]

  get '/signin',    to: 'sessions#new'
  get '/signout',   to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/user/:id', to: 'users#show', as: 'user'

  get 'orders/:id', to: 'orders#show', as: 'order'

  root to: 'products#index'

  resources :account_activations, only: [:edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
