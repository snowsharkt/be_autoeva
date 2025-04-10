Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users

    root to: 'dashboard#index'
  end

  authenticated :user, lambda { |u| u.admin? } do
    root to: 'admin/dashboard#index', as: :authenticated_root
  end

  # API routes for authentication
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'

    scope :users do
      get "prediction-history", to: "users#prediction_history"
      get 'profile', to: 'users#profile'
      post 'change_password', to: 'users#change_password'
    end

    post "predicts", to: "predictions#predict"

    resources :users, only: [:index, :show, :update, :destroy]
    resources :sale_posts do
      resources :sale_post_images, only: [:create, :destroy]
    end

    resources :brands, only: [:index]
  end

  root to: 'home#index'
end
