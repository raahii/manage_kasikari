Rails.application.routes.draw do
  get 'kasikaris/index'

  get 'kasikaris/new'

  get 'kasikaris/create'

  get 'kasikaris/edit'

  get 'kasikaris/update'

  get 'kasikaris/destroy'

  root 'static_pages#home'
  get  '/help',    to:  'static_pages#help'
  get  '/about',   to:  'static_pages#about'
  get  '/contact', to:  'static_pages#contact'
  get  '/signup',  to:  'users#new'
  post '/signup',  to:  'users#create'

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get :friends
    end
  end

  resources :items

  resources :relationships, only: [:create, :destroy]
end
