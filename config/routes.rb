Rails.application.routes.draw do
  get 'products/:id', to: 'products#show', as: 'product'
  get 'products',     to: 'products#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
