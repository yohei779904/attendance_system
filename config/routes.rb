Rails.application.routes.draw do
  get 'sessions/new'
  root to: 'toppages#index'

  #下記3行はログイン機能
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  
  resources :users, only: [:show, :new, :create, :edit, :update] do
    
    resources :attends, only: [:index, :new, :create] 
  end

end
