Rails.application.routes.draw do
  mount Lookbook::Engine, at: "/lookbook", as: :lookbook if defined?(Lookbook)
  mount RailsIcons::Engine, at: "/rails_icons" if Rails.env.development?

  resource :session, only: %i[new create destroy]
  resource :account, only: %i[show], controller: "account"

  resources :invites, only: [], param: :token do
    member do
      get :accept
      post :complete
    end
  end

  namespace :admin do
    resources :invites, only: %i[index new create destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "about", to: "about#show"
  get "sponsorship", to: "sponsorship#show"
  resources :events, only: %i[index show], param: :slug do
    resource :rsvp, only: :create, controller: :event_rsvps
  end

  root "landing#show"
end
