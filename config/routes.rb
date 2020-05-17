Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "homepages#index"  # root_path

  get "/users", to: "users#index", as: "users"
  get "/users/:id", to: "users#show", as: "user"

  get "/login", to: "users#login_form", as: "login"
  post "/login", to: "users#login" 
  post "/logout", to: "users#logout", as: "logout"

  post '/votes/:work_id', to: 'votes#upvote', as: "upvote"

  # get "/users/current", to: "users#current", as: "current_user"

  resources :works
  # resources :users
end
