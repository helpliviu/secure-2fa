class Clients::PasswordsController < ApplicationController
  before_action :authenticate_client!

  def edit; end

  def update
    if current_client.update(password_params)
      current_client.generate_two_factor_secret_if_needed!
      redirect_to setup_2fa_path
    else
      render :edit
    end
  end

  private

  def password_params
    params.require(:client).permit(:password, :password_confirmation)
  end
end
