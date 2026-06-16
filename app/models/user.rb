class User < ApplicationRecord
  # Validations
  validates :uuid, presence: true,
            uniqueness: { scope: :project_id, message: "already exists for this project" }

  # Associations
  belongs_to :project
  has_many   :verifications, dependent: :destroy
  has_many   :logs,          dependent: :destroy

  # Delegate project relations for convenience
  delegate :client, :channel, :template, to: :project

  # ActiveRecord Encryption
  encrypts :uuid, deterministic: true

  # Scopes
  default_scope -> { order(:uuid) }
end
