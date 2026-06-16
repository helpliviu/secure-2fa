class OtpController < ApplicationController
  require "openssl"
  require "base64"

  # Skip client authentication — this is the public API
  skip_before_action :authenticate_client!

  before_action :find_project

  # POST api.secure-2fa.com/otp/generate
  # Decrypts caller data, finds/creates the user, generates and delivers OTP
  def generate
    uuid, to = decrypt(params[:encrypted_data], @project.secret_key).split("#")
    @user     = @project.users.find_or_create_by(uuid: uuid)

    unless @user.persisted?
      render json: { success: false, message: "Could not find or create user." },
             status: :unprocessable_entity
      return
    end

    # Purge old verifications beyond the store window
    @user.verifications
         .where("otp_sent_at < ?", ENV.fetch("OTP_STORE_MINS", 15).to_i.minutes.ago)
         .destroy_all

    verification = @user.verifications.create!(
      to:               to,
      user_agent:       params[:user_agent],
      ip_address:       params[:ip_address],
      lang:             params[:lang],
      template_request: params[:template_request]
    )

    if verification.persisted?
      @json_response = verification.generate_response
      @log_level     = :info
      render json: @json_response
    else
      @json_response = { success: false, message: "Error generating OTP." }
      @log_level     = :danger
      render json: @json_response, status: :unprocessable_entity
    end

    @user.logs.create!(message: @json_response[:message], level: @log_level.to_s)
  end

  # POST api.secure-2fa.com/otp/verify
  # Decrypts caller data, validates the submitted OTP code
  def verify
    uuid, otp = decrypt(params[:encrypted_data], @project.secret_key).split("#")
    @user      = @project.users.find_by(uuid: uuid)

    unless @user
      render json: { verified: false, message: "User not found." }, status: :not_found
      return
    end

    verification = @user.verifications.first

    @json_response, @log_level, status_code =
      if verification.nil? || verification.expired?
        [{ verified: false, message: "Invalid or expired OTP." }, :warning, :unauthorized]

      elsif verification.exceeded_attempts?
        [{ verified: false, message: "Too many attempts. Please request a new OTP." }, :danger, :too_many_requests]

      elsif verification.unauthorized_device?(params[:user_agent], params[:ip_address])
        [{ verified: false, message: "Unauthorized device." }, :danger, :unauthorized]

      elsif verification.otp_code == otp
        verification.destroy
        [{ verified: true, message: "OTP verified successfully." }, :success, :ok]

      else
        verification.increment!(:attempts)
        [{ verified: false, message: "Invalid OTP code." }, :warning, :unauthorized]
      end

    render json: @json_response, status: status_code

    @user.logs.create!(message: @json_response[:message], level: @log_level.to_s)

    # Fire webhook asynchronously if configured
    if @project.webhook_url.present?
      WebhookCallJob.perform_later(@project.webhook_url, params[:encrypted_data], @json_response)
    end
  end

  protected

  # AES-256-CBC decryption — IV is prepended to the Base64-encoded payload
  def decrypt(encrypted_data, key)
    encoded   = Base64.decode64(encrypted_data)
    iv        = encoded[0, 16]
    encrypted = encoded[16..]

    decipher         = OpenSSL::Cipher::AES256.new(:CBC)
    decipher.decrypt
    decipher.key     = key
    decipher.iv      = iv

    decipher.update(encrypted) + decipher.final
  end

  private

  def find_project
    @project = Project.find_by(public_key: params[:public_key])
    render json: { success: false, message: "Project not found." }, status: :not_found unless @project
  end
end
