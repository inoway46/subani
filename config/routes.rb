Rails.application.routes.draw do
  root 'homes#index'
  post '/homes/guest_sign_in', to: 'homes#guest_sign_in'
  devise_for :users
  resources :schedules
  resources :contents
  resources :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
end
