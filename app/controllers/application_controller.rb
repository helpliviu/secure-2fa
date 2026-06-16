class ApplicationController < ActionController::Base
  before_action :authenticate_client!

  # Expose current_client helper to views
  helper_method :current_client

  # Handle unauthorized access gracefully
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end if defined?(CanCan)
end
