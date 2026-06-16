class Project < ApplicationRecord
  # Validations
  validates :title,              presence: true
  validates :expiration_seconds, numericality: { only_integer: true, greater_than: 50 }
  validates :max_attempts,       numericality: { only_integer: true, greater_than: 0 }
  validates :webhook_url, allow_blank: true,
            format: { with: URI::DEFAULT_PARSER.make_regexp, message: "%{value} must be a valid URL" }

  # Associations
  belongs_to :client
  belongs_to :channel
  belongs_to :template
  has_many   :users, dependent: :destroy
  has_many   :logs,  dependent: :destroy

  # Nested attributes — allows creating/updating channel & template inline with project
  accepts_nested_attributes_for :channel
  accepts_nested_attributes_for :template

  # ActiveRecord Encryption (Rails 7)
  encrypts :public_key,  deterministic: true
  encrypts :secret_key
  encrypts :webhook_url

  # Scopes
  default_scope -> { order(:title) }
  scope :deliveries_by, ->(method) {
    includes(:channel).where("channels.method = ?", method).references(:channels)
  }

  # Callbacks
  before_create :generate_keys

  private

  # Auto-generate unique public/secret key pair on project creation
  def generate_keys
    self.public_key = SecureRandom.hex(16) # 32-char hex — project identifier
    self.secret_key = SecureRandom.hex(16) # 32-char hex — AES-256 encryption key
  end
end
