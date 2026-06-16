class Channel < ApplicationRecord
  include CheckLinkedProjects

  # Validations
  validates :title,    presence: true
  validates :method,   presence: true,
            inclusion: { in: -> (_) { Channel.delivery_methods },
                         message: "%{value} is not a valid delivery method" }
  validates :provider, presence: true,
            inclusion: { in: -> (_) { Channel.provider_handles },
                         message: "%{value} is not a valid provider" }
  validates :credentials, presence: true
  validate  :credentials_is_hash

  # Associations
  belongs_to :client
  has_many   :projects, dependent: :nullify

  # Serialize credentials as Hash (stored as JSON text in DB)
  serialize :credentials, Hash

  # ActiveRecord Encryption
  encrypts :credentials

  # Scopes
  default_scope -> { order(:title) }

  # Callbacks
  before_save :normalize_credentials

  # ── Class methods ──────────────────────────────────────────────────

  def self.delivery_methods
    %w[email sms]
  end

  def self.provider_handles
    providers.map { |p| p[:handle] }
  end

  def self.providers_by_method(method)
    providers.select { |p| p[:methods].include?(method) }
             .map    { |p| [p[:name], p[:handle]] }
  end

  # Full provider registry — add new providers here (see section 3.3)
  def self.providers
    [
      {
        name: "Postmark", handle: "postmark", methods: %w[email],
        credentials: { email: %w[server_token from_email] }
      },
      {
        name: "Sendgrid", handle: "sendgrid", methods: %w[email],
        credentials: { email: %w[api_key from_email] }
      },
      {
        name: "Clicksend", handle: "clicksend", methods: %w[email sms],
        credentials: {
          email: %w[username api_key from_email],
          sms:   %w[username api_key sender_id]
        }
      },
      {
        name: "Mailjet", handle: "mailjet", methods: %w[email],
        credentials: { email: %w[api_key secret_key from_email from_name] }
      },
      {
        name: "Sparkpost", handle: "sparkpost", methods: %w[email],
        credentials: { email: %w[api_key from_email] }
      },
      {
        name: "Elasticemail", handle: "elasticemail", methods: %w[email],
        credentials: { email: %w[api_key from_email] }
      },
      {
        name: "Twilio", handle: "twilio", methods: %w[sms],
        credentials: { sms: %w[account_sid auth_token from] }
      },
      {
        name: "Plivo", handle: "plivo", methods: %w[sms],
        credentials: { sms: %w[auth_id auth_token from_sender_id] }
      },
      {
        name: "SMTP", handle: "smtp", methods: %w[email],
        credentials: {
          email: %w[address port username password from_email
                    authentication enable_starttls_auto ssl tls verify_mode]
        }
      }
    ]
  end

  private

  def normalize_credentials
    self.credentials = credentials.to_h if credentials.is_a?(String)
  end

  def credentials_is_hash
    unless credentials.is_a?(Hash)
      errors.add(:credentials, "must be a valid JSON object / Hash")
    end
  end
end
