class TwilioService
  require "twilio-ruby"

  def self.send_message(method, credentials, to, message_body, _message_subject)
    account_sid = credentials[:account_sid] || credentials["account_sid"]
    auth_token  = credentials[:auth_token]  || credentials["auth_token"]
    from        = credentials[:from]        || credentials["from"]

    client  = Twilio::REST::Client.new(account_sid, auth_token)
    message = client.messages.create(from: from, to: to, body: message_body)

    # Poll for final delivery status (allow up to 5s)
    sleep 2
    final_status = client.messages(message.sid).fetch.status

    status = %w[delivered sent].include?(final_status) ? "delivered" : "not_delivered"

    { identifier: message.sid, status: status }
  end
end
