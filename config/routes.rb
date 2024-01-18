Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  mount ActionCable.server => '/cable'

  mount Sidekiq::Web => '/sidekiq'

  # Defines the root path route ("/")
  # root "posts#index"

  post '/auth/register', to: 'registrations#register'
  post '/auth/login', to: 'sessions#login'
  get '/auth/google_login', to: 'sessions#google_login'
  get '/auth/callback', to: 'sessions#callback'
  post '/auth/forgot_password', to: 'reset_password#create'
  post '/auth/reset_password', to: 'reset_password#reset_password'
  get '/auth/confirm_email', to: 'confirmations#confirm_email'

  namespace :api do
    namespace :v1 do
      post '/image_upload', to: 'image_uploads#create'
      post '/image_delete', to: 'image_uploads#destroy'
      resources :users, only: %i[index] do
        collection do
          get 'me'
        end
      end
      resources :projects, only: %i[index show create] do
        collection do
          put 'update'
        end
      end
      resources :cards, only: %i[show create destroy] do
        collection do
          put 'update'
          post 'move_card'
        end
      end
      resources :columns, only: %i[create destroy] do
        collection do
          put 'update'
          post 'move_column'
        end
      end
      resources :tasks, only: %i[create destroy] do
        collection do
          put 'update'
          post 'move_task'
          post 'generate_tasks'
        end
      end
      resources :comments, only: %i[create destroy] do
        collection do
          put 'update'
        end
      end
    end
  end
end
