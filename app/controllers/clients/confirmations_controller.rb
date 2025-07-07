# frozen_string_literal: true

class Clients::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      redirect_to edit_client_password_path(resource, confirmation_token: params[:confirmation_token]), notice: "Please set your password"
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
