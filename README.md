# Secure-2FA

**Free, open-source Two-Factor Authentication service built with Ruby on Rails 7.**

> Written by Liviu Dumitru — Kentucky, USA, March 2025.  
> Full technical documentation: [The need for 2FA](https://secure-2fa.com)

---

## Overview

Secure-2FA is a Rails 7 application that exposes a simple two-call API allowing any website to add OTP-based 2FA to its login flow — delivered by email or SMS through popular third-party providers.

- **Two API endpoints:** `POST /otp/generate` and `POST /otp/verify`
- **AES-256 encrypted** data in transit and at rest (Rails 7 ActiveRecord Encryption)
- **Multiple delivery providers:** Postmark, Sendgrid, Mailjet, Sparkpost, Elasticemail, SMTP, Twilio, Plivo, Clicksend
- **Background delivery** via Sidekiq + Redis
- **Multi-language** OTP message templates
- **TOTP-secured** admin backend (Google Authenticator / Twilio Authy)
- **Self-hostable** via Docker

---

## Prerequisites

| Tool       | Version     |
|------------|-------------|
| Ruby       | 3.1+        |
| Rails      | 7.x         |
| PostgreSQL | 14+         |
| Redis      | 6+          |
| Node.js    | 18+         |
| Yarn       | 1.22+       |

---

## Setup

```bash
# 1. Clone the repository
git clone https://github.com/helpliviu/secure-2fa
cd secure-2fa

# 2. Install dependencies
bundle install
yarn install

# 3. Configure environment
cp .env.example .env
# Edit .env with your database credentials and encryption keys

# 4. Generate encryption keys
bin/rails credentials:edit
# Add: active_record_encryption: { primary_key: ..., deterministic_key: ..., key_derivation_salt: ... }

# 5. Setup database
bin/rails db:create db:migrate

# 6. Start the application
bin/dev
# → Rails server at http://localhost:3000
# → Sidekiq worker for background OTP delivery
```

---

## Application Structure

```
app/
├── controllers/
│   ├── otp_controller.rb              # Public API: generate + verify
│   ├── projects_controller.rb
│   ├── channels_controller.rb
│   ├── templates_controller.rb
│   ├── logs_controller.rb             # Dashboard
│   ├── clients_controller.rb          # Admin: client management
│   └── clients/
│       ├── registrations_controller.rb
│       ├── confirmations_controller.rb
│       ├── sessions_controller.rb      # Includes TOTP verify flow
│       ├── passwords_controller.rb
│       └── two_factor_auths_controller.rb
├── jobs/
│   ├── deliver_otp_job.rb             # Async OTP delivery via Sidekiq
│   └── webhook_call_job.rb            # Async webhook notification
├── models/
│   ├── client.rb                      # Developer account (Devise + TOTP)
│   ├── project.rb                     # 2FA project with keys
│   ├── channel.rb                     # Delivery provider config
│   ├── template.rb                    # OTP message template
│   ├── template_version.rb            # Per-language template body
│   ├── user.rb                        # End-user UUID registry
│   ├── verification.rb                # OTP generation/verification record
│   ├── log.rb                         # Audit log
│   └── concerns/
│       └── check_linked_projects.rb
└── services/
    ├── postmark_service.rb
    ├── sendgrid_service.rb
    ├── mailjet_service.rb
    ├── sparkpost_service.rb
    ├── elasticemail_service.rb
    ├── smtp_service.rb
    ├── twilio_service.rb
    ├── plivo_service.rb
    └── clicksend_service.rb
```

---

## API Usage

### POST `/otp/generate`

```ruby
# Encrypt: "uuid#email_or_phone" with AES-256-CBC using your project secret_key
# Then POST to: https://api.secure-2fa.com/otp/generate
{
  encrypted_data: "base64_encrypted_string",
  public_key:     "your_project_public_key",
  lang:           "en",            # optional
  ip_address:     "1.2.3.4",       # optional
  user_agent:     "Mozilla/5.0…",  # optional
  template_request: false          # optional — true returns template, skips delivery
}
# Response: { success: true, message: "OTP generated successfully." }
```

### POST `/otp/verify`

```ruby
# Encrypt: "uuid#otp_code" with AES-256-CBC using your project secret_key
{
  encrypted_data: "base64_encrypted_string",
  public_key:     "your_project_public_key",
  ip_address:     "1.2.3.4",       # optional
  user_agent:     "Mozilla/5.0…"   # optional
}
# Response: { verified: true,  message: "OTP verified successfully." }
#        or { verified: false, message: "Invalid or expired OTP." }
```

---

## Environment Variables

| Variable                      | Description                                  |
|-------------------------------|----------------------------------------------|
| `APP_NAME`                    | Application name (default: `Secure-2FA`)     |
| `OTP_STORE_MINS`              | Minutes to keep old verifications (default: 15) |
| `DATABASE_URL`                | PostgreSQL connection string                 |
| `REDIS_URL`                   | Redis connection string                      |
| `OTP_SECRET_ENCRYPTION_KEY`   | 32-byte key for Devise TOTP secret           |
| `ENCRYPTION_PRIMARY_KEY`      | ActiveRecord Encryption primary key          |
| `ENCRYPTION_DETERMINISTIC_KEY`| ActiveRecord Encryption deterministic key    |
| `ENCRYPTION_KEY_DERIVATION`   | ActiveRecord Encryption derivation salt      |

---

## Adding a New Delivery Provider

1. Add entry to `Channel.providers` in `app/models/channel.rb`
2. Create `app/services/yourprovider_service.rb` implementing `self.send_message(method, credentials, to, body, subject)`
3. Add gem to `Gemfile` if needed and run `bundle install`
4. Service must return `{ identifier: "...", status: "delivered"|"not_delivered"|"not-known" }`

---

## License

MIT — free to use, fork, and deploy.

## Contact

Free programming assistance: [helpliviu.org](https://helpliviu.org)
