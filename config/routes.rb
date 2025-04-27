Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users
    resources :comments, only: [:index, :show, :destroy]
    resources :reports, only: [:index, :show, :update, :destroy] do
      member do
        post 'resolve'
        post 'reject'
        post 'ban_user'
        post 'delete_post'
      end
    end

    root to: 'dashboard#index'
  end

  authenticated :user, lambda { |u| u.admin? } do
    root to: 'admin/dashboard#index', as: :authenticated_root
  end

  # API routes for authentication
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      confirmations: 'api/auth/confirmations',
      passwords: 'api/auth/passwords',
    }

    scope :users do
      get "prediction-history", to: "users#prediction_history"
      get 'profile', to: 'users#profile'
      post 'change_password', to: 'users#change_password'
    end

    post "predicts", to: "predictions#predict"

    resources :users, only: [:index, :show, :update, :destroy] do
      collection do
        get "sale_posts", to: "users#get_posts"
      end
    end
    resources :sale_posts do
      resources :sale_post_images, only: [:create, :destroy]
      resources :favorites, only: [:create] do
        collection do
          delete 'destroy', to: 'favorites#destroy'
        end
      end
      resources :comments, only: [:index, :create]
      collection do
        post 'upload', to: 'sale_posts#upload'
        get 'show_user_post/:id', to: 'sale_posts#show_user_post'
        get "home", to: "sale_posts#home"
        get "search", to: "sale_posts#search"
      end
    end

    resources :comments, only: [:show, :update, :destroy]
    resources :favorites, only: [:index]
    resources :reports, only: [:index, :create]

    resources :brands, only: [:index]
    resources :models, only: [:index]
    resources :versions, only: [:index]
  end

  get '/images/:id', to: 'files#get_image', as: :custom_image

  root to: 'home#index'
end
