class PostmarkService
  def self.send_message(method, credentials, to, message_body, message_subject)
    server_token = credentials[:server_token] || credentials["server_token"]
    from_email   = credentials[:from_email]   || credentials["from_email"]

    uri  = URI.parse("https://api.postmarkapp.com/email")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"]             = "application/json"
    request["Accept"]                   = "application/json"
    request["X-Postmark-Server-Token"]  = server_token

    request.body = {
      From:     from_email,
      To:       to,
      Subject:  message_subject,
      HtmlBody: message_body,
      TextBody: message_body.gsub(/<[^>]+>/, "")
    }.to_json

    response = http.request(request)
    body     = JSON.parse(response.body) rescue {}

    identifier = body["MessageID"]
    status     = response.code.to_i == 200 ? "delivered" : "not_delivered"

    { identifier: identifier, status: status }
  end
end
