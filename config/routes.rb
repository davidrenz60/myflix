Myflix::Application.routes.draw do
  resources :videos, only: [:index, :show] do
    collection do
      get :search
    end
  end

  resources :categories, only: [:show]

  get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
end
