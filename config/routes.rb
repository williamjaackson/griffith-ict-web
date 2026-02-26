Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#index"
  get "1", to: "pages#v1"
  get "2", to: "pages#v2"
  get "3", to: "pages#v3"
  get "4", to: "pages#v4"
  get "5", to: "pages#v5"
  get "6", to: "pages#v6"
  get "7", to: "pages#v7"
  get "8", to: "pages#v8"
  get "9", to: "pages#v9"
end
