class Client < ApplicationRecord
  # Devise modules
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :lockable,
         :timeoutable,
         :two_factor_authenticatable,
         otp_secret_encryption_key: ENV["OTP_SECRET_ENCRYPTION_KEY"]

  # Validations
  validates :email, presence: true, uniqueness: true,
            format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "is not a valid email address" }

  # Associations
  has_many :projects,  dependent: :destroy
  has_many :channels,  dependent: :destroy
  has_many :templates, dependent: :destroy
  has_many :logs,      dependent: :destroy

  # ActiveRecord Encryption (Rails 7)
  encrypts :email,           deterministic: true
  encrypts :otp_secret,      deterministic: true
  encrypts :otp_backup_codes

  # Scopes
  default_scope -> { order(id: :desc) }

  # Callbacks
  before_create :setup_admin

  # Serialize backup codes as Array
  serialize :otp_backup_codes, Array

  # ── Instance methods ──────────────────────────────────────────────

  # Generates TOTP secret if not already set
  def generate_two_factor_secret_if_needed!
    self.otp_secret ||= Client.generate_otp_secret
    save!
  end

  # Sends confirmation email on registration
  def generate_and_send_confirmation_instructions
    generate_confirmation_token! if confirmation_token.blank?
    send_confirmation_instructions
  end

  # Returns the otpauth:// URI for linking authenticator apps (QR code)
  def provision_uri
    label  = "#{ENV.fetch('APP_NAME', 'Secure-2FA')}: #{email}"
    issuer = ENV.fetch("APP_NAME", "Secure-2FA")
    otp_provisioning_uri(label, issuer: issuer)
  end

  # Generates 10 one-time backup codes (shown once after setup)
  def generate_backup_codes
    self.otp_backup_codes = Array.new(10) { SecureRandom.hex(3).upcase }
    save!
    otp_backup_codes
  end

  # Verifies and consumes a backup code (single use)
  def verify_backup_code(code)
    return false unless otp_backup_codes.include?(code)

    self.otp_backup_codes.delete(code)
    save!
    true
  end

  private

  # First registered client becomes admin automatically
  def setup_admin
    self.admin = true if Client.unscoped.count == 0
  end
end
