Rails.application.routes.draw do
  resources :listings
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logged_in', to: 'sessions#islogged_in?'

  resources :users, only: %i[create show index]

  namespace :api do
    namespace :v1 do
      resources :listings
    end
  end
end
