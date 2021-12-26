Rails.application.routes.draw do
  namespace :line do
    get 'authentications/link'
    get 'authentications/create'
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'homes#index'
  post '/homes/guest_sign_in', to: 'homes#guest_sign_in'

  resources :schedules

  resources :contents do
    member do
      patch 'flag_off'
      patch 'line_on'
      patch 'line_off'
    end

    collection do
      get 'amazon_list'
      get 'abema_list'
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }

  namespace :line do
    get 'link', to: 'authentications#link'
    post 'link', to: 'authentications#create'
  end
  post '/callback', to: 'line_bot#callback'
end
