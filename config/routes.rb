require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resource :registrations, only: [:new, :create] do
    collection do
      get :confirm
      get :generate
    end
  end
  resource :sessions, only: [:new, :create, :destroy] do
    get '/', action: :create
    get '/token', as: :token, action: :token
  end

  namespace :api do
    get '/', to: 'api/api#root'

    resources :invoices do
      member do
        get :send_email
      end
    end

    match '*unmatched', to: 'api/api#not_found', via: :all
  end

  namespace :internal do
    resources :invoices
  end

  root 'application#root'
end
