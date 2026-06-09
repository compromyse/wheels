Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  root to: "home#index"

  namespace :admin do
    root to: "dashboard#index"
    resources :productions,   only: [ :index, :new, :create, :destroy ]
    resources :distributions, only: [ :index, :new, :create, :edit, :update, :destroy ]
    resources :users,         only: [ :index, :new, :create, :destroy ]
  end

  resources :bike_requests,  only: [ :update ]
  resources :productions,    only: [ :show ]
  resources :distributions,  only: [ :show ] do
    resources :bike_requests, only: [ :new, :create ]
  end
end
