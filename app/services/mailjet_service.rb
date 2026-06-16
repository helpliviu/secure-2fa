class MailjetService
  require "mailjet"

  def self.send_message(method, credentials, to, message_body, message_subject)
    Mailjet.configure do |config|
      config.api_key    = credentials[:api_key]    || credentials["api_key"]
      config.secret_key = credentials[:secret_key] || credentials["secret_key"]
      config.api_version = "v3.1"
    end

    from_email = credentials[:from_email] || credentials["from_email"]
    from_name  = credentials[:from_name]  || credentials["from_name"]

    client = Mailjet::Send.create(
      messages: [{
        From:     { Email: from_email, Name: from_name },
        To:       [{ Email: to }],
        Subject:  message_subject,
        HTMLPart: message_body
      }]
    )

    msg        = client.attributes["Messages"]&.first || {}
    identifier = msg["To"]&.first&.dig("MessageID")&.to_s
    status     = msg["Status"] == "success" ? "delivered" : "not_delivered"

    { identifier: identifier, status: status }
  end
end
