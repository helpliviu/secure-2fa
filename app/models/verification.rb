class Verification < ApplicationRecord
  # Validations
  validates :to, presence: true
  validates :delivery_status,
            inclusion: { in: -> (_) { Verification.delivery_statuses },
                         message: "%{value} is not a valid delivery status" }

  # Associations
  belongs_to :user
  delegate   :client, :project, :channel, :template, to: :user

  # ActiveRecord Encryption
  encrypts :to,         deterministic: true
  encrypts :otp_code
  encrypts :user_agent
  encrypts :ip_address

  # Scopes
  default_scope { order(otp_sent_at: :desc) }

  # Callbacks
  before_create :validate_destination
  before_create :generate_otp
  after_create  :deliver_otp

  # ── Class methods ──────────────────────────────────────────────────

  def self.delivery_statuses
    %w[not-known delivered not_delivered]
  end

  # ── Instance methods ───────────────────────────────────────────────

  # OTP code is expired if sent more than project.expiration_seconds ago
  def expired?
    otp_sent_at < project.expiration_seconds.seconds.ago
  end

  # Max verification attempts exceeded
  def exceeded_attempts?
    attempts >= project.max_attempts
  end

  # Returns true if IP or user-agent don't match stored values (device check)
  def unauthorized_device?(incoming_user_agent, incoming_ip)
    return false unless user_agent.present? && ip_address.present?

    user_agent != incoming_user_agent || ip_address != incoming_ip
  end

  # Resolved subject from the matching template version
  def subject
    resolved_template_version.subject
  end

  # Resolved body from the matching template version with OTP injected
  def body
    resolved_template_version.body.gsub("{{OTP_CODE}}", otp_code)
  end

  # Build the JSON response returned to the API caller
  def generate_response
    {
      success: true,
      message: "OTP generated successfully.",
      subject: template_request? ? subject : nil,
      body:    template_request? ? body    : nil
    }
  end

  private

  # Validate email format or E.164 phone number
  def validate_destination
    if to.include?("@")
      begin
        parsed = Mail::Address.new(to)
        valid  = parsed.address == to && parsed.domain&.include?(".")
        unless valid
          errors.add(:to, "is not a valid email address")
          throw(:abort)
        end
      rescue
        errors.add(:to, "is not a valid email address")
        throw(:abort)
      end
    else
      # Basic E.164 validation: +[country code][number], 7-15 digits
      unless to.match?(/\A\+[1-9]\d{6,14}\z/)
        errors.add(:to, "is not a valid phone number (use E.164 format, e.g. +14155552671)")
        throw(:abort)
      end
    end
  end

  # Generate a random 6-digit OTP code
  def generate_otp
    self.otp_code    = rand(100_000..999_999).to_s
    self.otp_sent_at = Time.current
    self.attempts    = 0
  end

  # Enqueue async delivery job (Sidekiq)
  def deliver_otp
    DeliverOtpJob.perform_later(id)
  end

  # Find the template version matching the requested language, fallback to first
  def resolved_template_version
    template.template_versions.find_by(lang: lang) ||
      template.template_versions.first
  end
end
