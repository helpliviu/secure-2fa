class Log < ApplicationRecord
  # Validations
  validates :message, presence: true
  validates :level,   presence: true,
            inclusion: { in: -> (_) { Log.levels },
                         message: "%{value} is not a valid log level" }

  # Associations
  belongs_to :client
  belongs_to :project
  belongs_to :user

  # Scopes
  default_scope -> { order(id: :desc) }
  scope :filter_by_levels, ->(levels_array) {
    where(level: Array(levels_array))
  }

  # Callbacks
  before_create :resolve_relations

  def self.levels
    %w[success info warning danger]
  end

  private

  # Auto-fill project_id and client_id from the user association
  def resolve_relations
    self.project_id = user.project.id
    self.client_id  = user.project.client.id
  end
end
