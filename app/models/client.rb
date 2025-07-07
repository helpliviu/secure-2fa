class Client < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable

  def generate_two_factor_secret_if_needed!
    self.otp_secret ||= Client.generate_otp_secret
  end

  def generate_and_send_confirmation_instructions
    generate_confirmation_token! if confirmation_token.blank?
    send_confirmation_instructions
  end

  def provision_uri
    label = "#{ENV["APP_NAME"]}: #{email}"
    issuer = ENV["APP_NAME"]
    otp_provisioning_uri(label, issuer: issuer)
  end

  def generate_backup_codes
    self.otp_backup_codes = 10.times.map { SecureRandom.hex(3).upcase }
    save
  end

  def verify_backup_code(code)
    if otp_backup_codes.include?(code)
      self.otp.backup_codes.delete(code)
      save
      true
    else
      false
    end
  end
end
