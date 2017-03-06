Rails.application.routes.draw do
  root 'static_pages#home'
  get '/notification', to: 'users#notification'
  get  '/contact',     to: 'static_pages#contact'
  get  '/signup',      to: 'users#new'
  post '/signup',      to: 'users#create'

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get :friends
      get :items
    end
  end

  resources :items
  resources :relationships, only: [:create, :destroy]
  resources :kasikaris
  get '/kasikaris/new/:id', to: 'kasikaris#new_kari', as: 'new_kari'

  post '/subscribe'   => 'subscriptions#create'
  post '/unsubscribe' => 'subscriptions#destroy'
  post "/push"        => "subscriptions#push"

end
