# frozen_string_literal: true

class Clients::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(signup_params)
    resource.save
    if resource.persisted?
      resource.generate_and_send_confirmation_instructions
      render json: { message: "Please confirm your
email to complete registration." }
    else
      render json: { errors: resource.errors.full_messages, status: :unprocessable_entity }
    end
  end

  private

  def signup_params
    params.require(:client).permit(:email)
  end
end
