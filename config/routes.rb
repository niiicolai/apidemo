Rails.application.routes.draw do
  devise_for :users
  resources :articles
  resources :static_pages
  root 'articles#index'

  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
        match '/sessions' => 'sessions#create', :via => :post
        match '/sessions/:id' => 'sessions#destroy', :via => :delete
      match '/articles/:id' => 'articles#index', :via => :get
      match '/articles/:id' => 'articles#create', :via => :post
      match '/articles/show/:id' => 'articles#show', :via => :get
      match '/articles/:id' => 'articles#destroy', :via => :delete
      match '/articles/:id' => 'articles#update', :via => :put
    end
  end
end
