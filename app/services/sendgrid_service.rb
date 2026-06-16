class SendgridService
  require "sendgrid-ruby"
  include SendGrid

  def self.send_message(method, credentials, to, message_body, message_subject)
    api_key    = credentials[:api_key]    || credentials["api_key"]
    from_email = credentials[:from_email] || credentials["from_email"]

    from    = Email.new(email: from_email)
    to_addr = Email.new(email: to)
    content = Content.new(type: "text/html", value: message_body)
    mail    = Mail.new(from, message_subject, to_addr, content)

    sg       = SendGrid::API.new(api_key: api_key)
    response = sg.client.mail._("send").post(request_body: mail.to_json)

    identifier = response.headers["X-Message-Id"]
    status     = response.status_code.to_i == 202 ? "delivered" : "not_delivered"

    { identifier: identifier, status: status }
  end
end
