Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/contact',     to: 'static_pages#contact'
  get  '/signup',      to: 'users#new'
  post '/signup',      to: 'users#create'
  get    '/login',     to: 'sessions#new'
  post   '/login',     to: 'sessions#create'
  delete '/logout',    to: 'sessions#destroy'
  get '/notification', to: 'notifications#index'

  resources :users do
    member do
      get :friends
      get :items
      get :kasikaris
    end
  end
  get '/search', to: 'users#search', as: 'search_user'

  resources :relationships, only: [:create, :destroy]
  resources :items, except: [:index]
  resources :kasikaris, except: [:index]

  get '/kasikaris/new/:id', to: 'kasikaris#new_with_item', as: 'new_kari'

  post '/subscribe'   => 'subscriptions#create'
  post '/unsubscribe' => 'subscriptions#destroy'
  post "/push"        => "subscriptions#push"

end
