class WebhookCallJob < ApplicationJob
  queue_as :default

  def perform(webhook_url, encrypted_data, json_response)
    uri  = URI.parse(webhook_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"

    request = Net::HTTP::Post.new(uri.path.presence || "/")
    request["Content-Type"] = "application/json"
    request.body = {
      encrypted_data: encrypted_data,
      response:       json_response
    }.to_json

    http.request(request)
  rescue URI::InvalidURIError, SocketError, Net::OpenTimeout => e
    Rails.logger.error "[WebhookCallJob] Failed to call webhook #{webhook_url}: #{e.message}"
  end
end
