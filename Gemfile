source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

# Core
gem "rails", "~> 7.1.0"
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"

# Assets
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jsbundling-rails"
gem "cssbundling-rails"

# Authentication
gem "devise"
gem "devise-two-factor"
gem "rqrcode"

# Background jobs
gem "sidekiq"
gem "redis", ">= 4.0.1"

# Pagination
gem "kaminari"

# Email / SMS delivery providers
gem "twilio-ruby"
gem "mailjet"
gem "plivo"
gem "sendgrid-ruby"

# Utilities
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
end

group :development do
  gem "web-console"
  gem "foreman"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
