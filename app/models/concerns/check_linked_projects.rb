module CheckLinkedProjects
  extend ActiveSupport::Concern

  included do
    before_destroy :ensure_no_linked_projects
  end

  private

  def ensure_no_linked_projects
    if projects.count > 0
      errors.add(:base, "Cannot delete: resource is linked to one or more projects.")
      throw(:abort)
    end
  end
end
