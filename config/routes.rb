Rails.application.routes.draw do
  root 'schedules#index'
  resources :schedules
  resources :contents
end
