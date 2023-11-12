Rails.application.routes.draw do
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
      get :open_slots, controller_name: 'Api::V1::Slots', action: :index
      post :reserve_slot, controller_name: 'Api::V1::Slots'
      post :free, controller_name: 'Api::V1::Slots'
      patch :update_slot, controller_name: 'Api::V1::Slots', action: :update
      # user routes
      get :my_slots, controller_name: 'Api::V1::Slots', action: :index
    end
  end
end
