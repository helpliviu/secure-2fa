source "https://rubygems.org"
ruby "3.3.5"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# gem "bcrypt", "~> 3.1.7"

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false

gem "kamal", require: false

gem "thruster", require: false

gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", "~> 7.1.0", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

gem "rexml"
gem "devise" # Authentication system
gem "devise-two-factor" # Devise addon for TOTP authenticator
gem "rqrcode" # QR code generator needed to link authenticator applications
gem "dotenv-rails" # Storing environment variables
gem "phonelib" # Google’s library to validate phone formats
# gems for email/sms delivery services
gem "twilio-ruby"
gem "mailjet"
gem "plivo"
gem "sendgrid-ruby"

gem "pry"
gem "pry-rails"
