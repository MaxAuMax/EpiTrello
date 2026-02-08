Rails.application.routes.draw do
  get "users/show"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root to: 'pages#landing'
  
  get 'users/:id', to: 'users#show', as: 'user'

  resources :projects do
    resources :tasks do
      resources :comments, only: [:create, :destroy]
      member do
        get :delete
      end
    end
  end

  # Task status update for drag & drop
  patch 'tasks/:id/update_status', to: 'tasks#update_status', as: 'update_task_status'
  
  # Task statuses (columns) management
  resources :task_statuses, only: [:new, :create, :edit, :update, :destroy] do
    member do
      get :delete
      patch :move
      patch :move_all_cards
    end
  end
end
