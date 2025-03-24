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
    devise_scope :user do
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'
      post 'sign_up', to: 'registrations#create'
      get 'current_user', to: 'sessions#show'
    end

    resources :users, only: [:index, :show, :update, :destroy]
    get 'profile', to: 'users#profile'
    post 'change_password', to: 'users#change_password'
  end

  root to: 'home#index'
end
