module TemplatesHelper
  def markup_options
    Template.body_markups.map { |m| [m.upcase, m] }
  end

  def language_options
    TemplateVersion.languages.map { |l| [l.upcase, l] }
  end
end
