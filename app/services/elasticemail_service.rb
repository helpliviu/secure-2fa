class ElasticemailService
  def self.send_message(method, credentials, to, message_body, message_subject)
    api_key    = credentials[:api_key]    || credentials["api_key"]
    from_email = credentials[:from_email] || credentials["from_email"]

    uri    = URI.parse("https://api.elasticemail.com/v2/email/send")
    http   = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.set_form_data(
      apikey:          api_key,
      from:            from_email,
      to:              to,
      subject:         message_subject,
      bodyHtml:        message_body,
      isTransactional: true
    )

    response   = http.request(request)
    parsed     = JSON.parse(response.body) rescue {}
    identifier = parsed.dig("data", "messageid")
    status     = parsed["success"] ? "delivered" : "not_delivered"

    { identifier: identifier, status: status }
  end
end
