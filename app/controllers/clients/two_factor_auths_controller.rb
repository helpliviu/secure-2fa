class Clients::TwoFactorAuthsController < ApplicationController
  before_action :authenticate_client!

  def new
    @qr_code = RQRCode::QRCode.new(current_client.provision_uri).as_png(size: 200).to_data_url
  end

  def verify
    if current_client.validate_and_consume_otp!(params[:otp_attempt])
      current_client.update(otp_required_for_login: true)
      redirect_to root_path, notice: "2FA successfully
enabled"
    else
      flash[:alert] = "Invalid OTP code"
      render :new
    end
  end

  def generate_backup_codes
    current_client.generate_backup_codes
    # respond with modal to show the backup codes once
  end
end
