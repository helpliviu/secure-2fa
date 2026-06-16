class Clients::TwoFactorAuthsController < ApplicationController
  before_action :authenticate_client!

  # Step 3: show QR code to link authenticator app
  def new
    @qr_code = RQRCode::QRCode.new(current_client.provision_uri)
                              .as_png(size: 200)
                              .to_data_url
  end

  # Verify TOTP code from authenticator app and enable 2FA
  def verify
    if current_client.validate_and_consume_otp!(params[:otp_attempt])
      current_client.update!(otp_required_for_login: true)
      redirect_to root_path, notice: "Two-factor authentication enabled successfully."
    else
      flash.now[:alert] = "Invalid OTP code. Please try again."
      render :new
    end
  end

  # Generate and display backup codes (one-time modal)
  def generate_backup_codes
    @backup_codes = current_client.generate_backup_codes
    # Respond with a modal/partial showing codes — client must save them
  end
end
