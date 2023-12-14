Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      post '/image_upload', to: 'image_uploads#create'
      post '/image_delete', to: 'image_uploads#destroy'
      resources :projects, only: [:index]
      resources :cards, only: %i[create destroy] do
        collection do
          put 'update'
          post 'move_card'
        end
      end
      resources :columns do
        collection do
          put 'update'
        end
      end
    end
  end
end
