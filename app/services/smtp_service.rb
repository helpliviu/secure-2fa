class SmtpService
  def self.send_message(method, credentials, to, message_body, message_subject)
    ActionMailer::Base.smtp_settings = {
      address:              credentials[:address]  || credentials["address"],
      port:                 (credentials[:port]    || credentials["port"]).to_i,
      user_name:            credentials[:username] || credentials["username"],
      password:             credentials[:password] || credentials["password"],
      authentication:       (credentials[:authentication] || credentials["authentication"] || "plain").to_sym,
      enable_starttls_auto: parse_bool(credentials[:enable_starttls_auto] || credentials["enable_starttls_auto"]),
      ssl:                  parse_bool(credentials[:ssl] || credentials["ssl"]),
      tls:                  parse_bool(credentials[:tls] || credentials["tls"])
    }

    from_email = credentials[:from_email] || credentials["from_email"]

    mail = ActionMailer::Base.mail(
      to:      to,
      from:    from_email,
      subject: message_subject,
      body:    message_body,
      content_type: "text/html"
    )
    mail.deliver

    { identifier: nil, status: nil }
  end

  def self.parse_bool(value)
    value.to_s.strip.downcase == "true"
  end
end
