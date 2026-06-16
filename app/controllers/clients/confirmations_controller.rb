class Clients::ConfirmationsController < Devise::ConfirmationsController
  # After email confirmation → redirect to password setup page
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      redirect_to edit_client_password_path(
        resource,
        confirmation_token: params[:confirmation_token]
      ), notice: "Email confirmed. Please set your password."
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
