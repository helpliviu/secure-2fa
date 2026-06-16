class ClicksendService
  def self.send_message(method, credentials, to, message_body, message_subject)
    username   = credentials[:username]   || credentials["username"]
    api_key    = credentials[:api_key]    || credentials["api_key"]
    sender_id  = credentials[:sender_id]  || credentials["sender_id"]
    from_email = credentials[:from_email] || credentials["from_email"]

    if method == "sms"
      endpoint = "https://rest.clicksend.com/v3/sms/send"
      body = {
        messages: [{
          source: ENV.fetch("APP_NAME", "Secure-2FA"),
          from:   sender_id,
          body:   message_body,
          to:     to
        }]
      }.to_json
    else
      endpoint = "https://rest.clicksend.com/v3/email/send"
      body = {
        to:      [{ email: to }],
        from:    { email: from_email },
        subject: message_subject,
        body:    message_body
      }.to_json
    end

    uri  = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/json"
    request.basic_auth(username, api_key)
    request.body = body

    response = http.request(request)
    parsed   = JSON.parse(response.body) rescue {}

    identifier = parsed.dig("data", "messages", 0, "message_id")
    status     = parsed["response_code"] == "SUCCESS" ? "delivered" : "not_delivered"

    { identifier: identifier, status: status }
  end
end
