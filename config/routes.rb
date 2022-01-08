Rails.application.routes.draw do
  namespace :line do
    get 'authentications/link'
    get 'authentications/create'
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'homes#index'
  post '/homes/guest_sign_in', to: 'homes#guest_sign_in'

  resources :schedules, except: %i[show]

  resources :contents, except: %i[show] do
    member do
      patch 'flag_off'
    end

    collection do
      get 'amazon_list'
      get 'abema_list'
    end
  end

  resource :profile, only: %i[show edit update]

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
  }

  namespace :line do
    get 'link', to: 'authentications#link'
    post 'link', to: 'authentications#create'
    post '/callback', to: 'line_bot#callback'
    resources :flags, only: %i[create destroy]
    resources :notifications, only: %i[create]
  end
end
