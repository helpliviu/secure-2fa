Rails.application.routes.draw do

  namespace :rui do
    get "about", to: "pages#about"
    get "pricing", to: "pages#pricing"
    get "dashboard", to: "pages#dashboard"
    get "projects", to: "pages#projects"
    get "project", to: "pages#project"
    get "messages", to: "pages#messages"
    get "message", to: "pages#message"
    get "assignments", to: "pages#assignments"
    get "calendar", to: "pages#calendar"
    get "people", to: "pages#people"
    get "profile", to: "pages#profile"
    get "activity", to: "pages#activity"
    get "settings", to: "pages#settings"
    get "notifications", to: "pages#notifications"
    get "billing", to: "pages#billing"
    get "team", to: "pages#team"
    get "integrations", to: "pages#integrations"
  end
  get "up" => "rails/health#show", as: :rails_health_check

  # resources :templates
  # resources :channels
  # resources :projects
  devise_for :clients, controllers: {
    registrations: "clients/registrations",
    #   confirmations: "clients/confirmations",
    sessions: "clients/sessions"
  }

  # devise_scope :client do
  #   get "clients/password/setup", to: "clients/passwords#edit", as: :edit_client_password
  #   patch "clients/password/setup", to: "clients/passwords#update"
  #   get "setup_2fa", to: "clients/two_factor_auths#new"
  #   post "verify_otp", to: "clients/two_factor_auths#verify"
  #   get "generate_backup_codes", to: "clients/two_factor_auths#generate_backup_codes"
  # end

  # require "sidekiq/web"
  # mount Sidekiq::Web => "/sidekiq"

  root action: :index, controller: "clients/welcome"
end
