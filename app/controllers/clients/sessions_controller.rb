class Clients::SessionsController < Devise::SessionsController
  # After password authentication: if 2FA is enabled, redirect to TOTP page
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

  # Show TOTP verification form
  def verify_otp
    @client = Client.find(session[:client_id])
  end

  # Process TOTP code or backup code submission
  def confirm_otp
    @client = Client.find(session[:client_id])

    if @client.validate_and_consume_otp!(params[:otp_attempt])
      sign_in(@client)
      redirect_to root_path, notice: "Signed in successfully using 2FA."
    elsif @client.verify_backup_code(params[:otp_attempt])
      sign_in(@client)
      redirect_to root_path, notice: "Signed in successfully using backup code."
    else
      flash.now[:alert] = "Invalid 2FA code or backup code. Please try again."
      render :verify_otp
    end
  end
end
