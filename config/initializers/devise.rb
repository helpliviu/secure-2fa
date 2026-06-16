# Devise configuration — only the keys relevant to this application.
# Run `rails generate devise:install` to regenerate the full file.

Devise.setup do |config|
  config.mailer_sender = "noreply@secure-2fa.com"

  # Use custom mailer for async email delivery via Sidekiq
  config.mailer = "Devise::Mailer"
  config.async  = true

  # ORM
  require "devise/orm/active_record"

  # Authentication keys
  config.authentication_keys = [:email]
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # Password settings
  config.stretches = Rails.env.test? ? 1 : 12
  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Confirmable
  config.confirm_within = 3.days
  config.reconfirmable = true

  # Lockable
  config.lock_strategy = :failed_attempts
  config.maximum_attempts = 10
  config.unlock_strategy = :both
  config.unlock_in = 1.hour

  # Timeoutable
  config.timeout_in = 30.minutes

  # Remember me
  config.remember_for = 2.weeks

  # Sign out
  config.sign_out_via = :delete
end
