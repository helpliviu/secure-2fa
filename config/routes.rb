Rails.application.routes.draw do
  # Root — dashboard (logs index)
  root "logs#index"

  # Devise routes for Client model with custom controllers
  devise_for :clients, controllers: {
    registrations: "clients/registrations",
    confirmations: "clients/confirmations",
    sessions:      "clients/sessions"
  }

  # Custom Devise scope routes
  devise_scope :client do
    get  "clients/password/setup", to: "clients/passwords#edit",   as: :edit_client_password
    patch "clients/password/setup", to: "clients/passwords#update"

    get  "setup_2fa",              to: "clients/two_factor_auths#new"
    post "verify_2fa",             to: "clients/two_factor_auths#verify"
    get  "generate_backup_codes",  to: "clients/two_factor_auths#generate_backup_codes"

    get  "verify_otp_login",       to: "clients/sessions#verify_otp"
    post "verify_otp_login",       to: "clients/sessions#confirm_otp"
  end

  # Main CRUD resources (scoped to authenticated client)
  resources :projects
  resources :channels
  resources :templates

  # Logs dashboard
  resources :logs, only: [:index]

  # Admin — clients management
  resources :clients, only: [:index, :show, :update]

  # OTP API — constrained to api. subdomain
  constraints subdomain: "api" do
    post "otp/generate", to: "otp#generate"
    post "otp/verify",   to: "otp#verify"
  end

  # Sidekiq Web UI (admin only — protect in production)
  # require "sidekiq/web"
  # mount Sidekiq::Web => "/sidekiq"
end
