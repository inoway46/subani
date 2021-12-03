Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'homes#index'
  post '/homes/guest_sign_in', to: 'homes#guest_sign_in'
  devise_for :users
  resources :schedules
  resources :contents do
    collection do
      get 'ranking'
      get 'amazon_list'
    end
  end
  resources :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
end
