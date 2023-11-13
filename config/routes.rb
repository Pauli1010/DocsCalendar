Rails.application.routes.draw do
  get 'users/index'
  get 'users/edit'
  get 'users/update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root to: redirect('api/v1/doctors#index', status: 302)

  namespace :api do
    namespace :v1 do
      resources :doctors, only: [:index, :show] do
        resources :slots do
          member do
            post :reserve_slot
            post :free
          end
        end
      end
      # shortened routes
      get :open_slots, to: 'slots#index'
      post :reserve_slot, to: 'slots#reserve_slot'
      post :free, to: 'slots#free'
      patch :update_slot, to: 'slots#update'
      # user routes
      resources :users
      get :my_data, to: 'users#my_data'
      get :my_slots, to: 'slots#my_slots'
      post 'registrations/create'
      post 'sessions/create'
      delete 'sessions/destroy'
    end
  end
end
