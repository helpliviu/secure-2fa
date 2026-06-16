class DeliverOtpJob < ApplicationJob
  queue_as :default

  def perform(verification_id)
    verification = Verification.find(verification_id)
    provider     = verification.channel.provider
    method       = verification.channel.method
    credentials  = verification.channel.credentials

    # Dynamically resolve service class: e.g. "postmark" => PostmarkService
    service_class = "#{provider.camelize}Service".constantize

    result = service_class.send_message(
      method,
      credentials,
      verification.to,
      verification.body,
      verification.subject
    )

    # Update delivery tracking fields
    verification.update!(
      delivery_identifier: result&.dig(:identifier),
      delivery_status:     result&.dig(:status) || "not-known"
    )
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "[DeliverOtpJob] Verification ##{verification_id} not found: #{e.message}"
  rescue NameError => e
    Rails.logger.error "[DeliverOtpJob] Unknown service provider: #{e.message}"
  end
end
