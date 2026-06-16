class TemplateVersion < ApplicationRecord
  # Validations
  validates :lang, presence: true,
            inclusion: { in: -> (_) { TemplateVersion.languages },
                         message: "%{value} is not a supported language code" },
            uniqueness: { scope: :template_id, message: "already has a version for this language" }

  validates :subject, presence: true, if: -> { template&.markup == "html" }

  validates :body, presence: true,
            format: { with: /OTP_CODE/, message: "must include the {{OTP_CODE}} placeholder" }

  # Associations
  belongs_to :template

  # Scopes
  default_scope -> { order(:lang) }

  def self.languages
    %w[en es fr de it jp nl hu ro pt tr pl cs sk bg hr sl lv lt et fi sv da nb]
  end
end
