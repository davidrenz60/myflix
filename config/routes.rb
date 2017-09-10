Myflix::Application.routes.draw do
  resources :videos, only: [:index, :show]
  resources :categories, only: [:show]

  get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
end
