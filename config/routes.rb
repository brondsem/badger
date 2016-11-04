Rails.application.routes.draw do
  devise_for :users
  resources :users, except: [:create] do
    post :admin_create, on: :collection
  end

  resources :events do
    resources :roles
    resources :attendees do
      collection do
        get :import
        post :import, to: "import#attendees"
        post :export
        post :export_blanks
      end

      member do
        post :check_in
      end
    end
  end

  root to: "home#index"
end
