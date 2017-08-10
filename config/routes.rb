Myflix::Application.routes.draw do
  root to: 'pages#front'
  resources :categories, only: [:show]
  resources :users, only: [:create]
  resources :videos, except: [:index] do
    collection do
      get :search, to: "videos#search"
    end

    resources :reviews, only: [:create]
  end

  resources :queue_items, only: [:create]

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  # get '/videos/:id', to: 'videos#show'

  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/my_queue', to: 'queue_items#index'
end
