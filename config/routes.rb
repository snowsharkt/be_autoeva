Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'login', to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
        post 'signup', to: 'registrations#create'
      end

      # resources :users, only: [:show, :update]
    end
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users

    root to: 'dashboard#index'
  end

  authenticated :user, lambda { |u| u.admin? } do
    root to: 'admin/dashboard#index', as: :authenticated_root
  end

  root to: 'home#index'
end
