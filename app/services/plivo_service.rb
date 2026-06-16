class PlivoService
  require "plivo"

  def self.send_message(method, credentials, to, message_body, _message_subject)
    auth_id        = credentials[:auth_id]        || credentials["auth_id"]
    auth_token     = credentials[:auth_token]     || credentials["auth_token"]
    from_sender_id = credentials[:from_sender_id] || credentials["from_sender_id"]

    client     = Plivo::RestClient.new(auth_id, auth_token)
    response   = client.messages.create(from_sender_id, [to], message_body)
    identifier = response.message_uuid&.first

    # Status can be retrieved later using identifier via Plivo message detail API
    { identifier: identifier, status: "not-known" }
  end
end
