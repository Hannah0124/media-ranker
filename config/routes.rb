Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "homepages#index"  # root_path

  resources :users, only: [:index, :show]

  get "/login", to: "users#login_form", as: "login"
  post "/login", to: "users#login" 
  post "/logout", to: "users#logout", as: "logout"

  resources :works

  resources :works do
    post "/upvote", to: "votes#upvote" #work_work_upvote_path
  end
end
