# frozen_string_literal: true

class Clients::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    if resource.otp_required_for_login
      session[:client_id] = resource.id
      redirect_to verify_otp_login_path
    else
      sign_in(resource)
      redirect_to root_path, notice: "Signed in successfully!"
    end
  end

  def verify_otp
    @client = Client.find(session[:client_id])
  end

  def confirm_otp
    @client = Client.find(session[:client_id])
    if @client.validate_and_consume_otp!(params[:otp_attempt])
      sign_in(@client)
      redirect_to root_path, notice: "Signed in successfully using 2FA"
    else
      if @client.verify_backup_code(params[:otp_attempt3])
        sign_in(@client)
        redirect_to root_path, notice: "Signed in successfully using backup code"
      else
        flash[:alert] = "Invalid 2FA or backup code"
        render :verify_otp
      end
    end
  end
end
