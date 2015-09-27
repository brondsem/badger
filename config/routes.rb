Rails.application.routes.draw do
  devise_for :users
  resources :users, except: [:create] do
    post :admin_create, on: :collection
  end

  root to: "home#index"
end
