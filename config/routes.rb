Myflix::Application.routes.draw do
  root to: "pages#front"
  get '/home', to: "videos#index"
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'

  resources :videos, only: [:show] do
    resources :reviews, only: [:create]
    collection do
      get :search
    end
  end

  resources :sessions, only: [:create]
  resources :users, only: [:create]
  resources :categories, only: [:show]
  get 'ui(/:action)', controller: 'ui'
end
