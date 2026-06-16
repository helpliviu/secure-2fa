class SparkpostService
  def self.send_message(method, credentials, to, message_body, message_subject)
    api_key    = credentials[:api_key]    || credentials["api_key"]
    from_email = credentials[:from_email] || credentials["from_email"]

    uri  = URI.parse("https://api.sparkpost.com/api/v1/transmissions")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request["Authorization"] = api_key
    request["Content-Type"]  = "application/json"
    request.body = {
      content: {
        from:      from_email,
        subject:   message_subject,
        html:      message_body
      },
      recipients: [{ address: { email: to } }]
    }.to_json

    response   = http.request(request)
    parsed     = JSON.parse(response.body) rescue {}
    identifier = parsed.dig("results", "id")
    status     = response.code.to_i == 200 ? "delivered" : "not_delivered"

    { identifier: identifier, status: status }
  end
end
