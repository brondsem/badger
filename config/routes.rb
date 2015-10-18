Rails.application.routes.draw do
  devise_for :users
  resources :users, except: [:create] do
    post :admin_create, on: :collection
  end

  resources :events do
    resources :roles
  end

  root to: "home#index"
end
