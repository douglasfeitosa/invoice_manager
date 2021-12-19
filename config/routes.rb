require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resource :sessions, only: [:new, :create, :destroy]

  namespace :internal do
    resources :invoices
  end

  root 'application#index'
end
