Rails.application.routes.draw do
  root 'schedules#index'
  devise_for :users
  resources :schedules
  resources :contents
  resources :users
end
