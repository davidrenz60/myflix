Myflix::Application.routes.draw do
  root to: "pages#front"
  get '/home', to: "videos#index"
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'
  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update_queue'
  get '/people', to: 'relationships#index'

  resources :relationships, only: [:destroy, :create]

  resources :videos, only: [:show] do
    resources :reviews, only: [:create]
    collection do
      get :search
    end
  end

  resources :queue_items, only: [:create, :destroy]
  resources :sessions, only: [:create]
  resources :users, only: [:create, :show]
  resources :categories, only: [:show]
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get '/invalid_token', to: 'reset_passwords#invalid_token'
  resources :forgot_passwords, only: [:create]
  resources :reset_passwords, only: [:show, :create]

  get 'ui(/:action)', controller: 'ui'
end
