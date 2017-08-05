Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  # get '/videos/:id', to: 'videos#show'
  resources :videos, except: [:index] do
    collection do
      get :search, to: "videos#search"
    end
  end
  resources :categories, only: [:show]
end
