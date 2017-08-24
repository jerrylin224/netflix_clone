Myflix::Application.routes.draw do
  root to: 'pages#front'
  resources :categories, only: [:show]
  resources :users, only: [:create, :show]
  resources :videos, except: [:index] do
    collection do
      get :search, to: "videos#search"
    end

    resources :reviews, only: [:create]
  end

  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  # get '/videos/:id', to: 'videos#show'

  resources :relationships, only: [:create, :destroy]
  get 'people', to: 'relationships#index'

  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :invitations, only: [:new, :create]

end
