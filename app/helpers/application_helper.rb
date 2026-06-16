module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice  then "alert-success"
    when :alert   then "alert-danger"
    when :warning then "alert-warning"
    when :info    then "alert-info"
    else "alert-secondary"
    end
  end

  def log_level_badge(level)
    map = { "success" => "success", "info" => "primary", "warning" => "warning", "danger" => "danger" }
    "badge bg-#{map.fetch(level, 'secondary')}"
  end

  def page_title(title)
    "#{title} — #{ENV.fetch('APP_NAME', 'Secure-2FA')}"
  end

  def friendly_time(dt)
    return "—" unless dt
    dt.strftime("%d %b %Y %H:%M UTC")
  end

  def truncate_key(str, length: 12)
    return "—" unless str.present?
    "#{str[0, length]}…"
  end
end
