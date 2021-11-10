Rails.application.routes.draw do
  root 'top#index'
  devise_for :users
  resources :schedules
  resources :contents
  resources :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
end
