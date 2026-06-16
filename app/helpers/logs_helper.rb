module LogsHelper
  def level_filter_options
    Log.levels.map { |l| [l.capitalize, l] }
  end
end
