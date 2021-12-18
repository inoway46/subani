Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'homes#index'
  post '/homes/guest_sign_in', to: 'homes#guest_sign_in'
  post '/callback', to: 'line_bot#callback'
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
  resources :schedules
  resources :contents do
    member do
      patch 'flag_off'
    end

    collection do
      get 'amazon_list'
      get 'abema_list'
    end
  end
  resources :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
end
