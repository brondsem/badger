Rails.application.routes.draw do
  devise_for :users
  resources :users, except: [:create] do
    post :admin_create, on: :collection
  end

  resources :events

  root to: "home#index"
end
