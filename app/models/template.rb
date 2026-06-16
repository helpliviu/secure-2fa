class Template < ApplicationRecord
  include CheckLinkedProjects

  # Validations
  validates :title,  presence: true
  validates :markup, presence: true,
            inclusion: { in: -> (_) { Template.body_markups },
                         message: "%{value} is not a valid markup type" }

  # Associations
  belongs_to :client
  has_many   :projects,          dependent: :nullify
  has_many   :template_versions, dependent: :destroy

  # Nested attributes — create/edit versions inline with the template form
  accepts_nested_attributes_for :template_versions,
                                allow_destroy: true,
                                reject_if: :all_blank

  # Scopes
  default_scope -> { order(:title) }

  def self.body_markups
    %w[html text]
  end
end
