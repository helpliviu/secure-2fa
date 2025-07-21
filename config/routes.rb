Rails.application.routes.draw do
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

  root action: :index, controller: "clients/welcome"
end
