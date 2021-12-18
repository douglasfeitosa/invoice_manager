Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :sessions, only: [:new, :create]

  scope 'internal' do
    get 'home', to: 'internal/home#index'
  end

  root 'application#index'

  match "*" => "application#not_found", via: [:get, :post, :patch, :put, :delete]
end
