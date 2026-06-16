# This file is auto-generated from the current state of the database.
# Run `bin/rails db:schema:load` to recreate the database from this file.
# Run `bin/rails db:migrate` to apply pending migrations incrementally.

ActiveRecord::Schema[7.1].define(version: 2025_03_01_000007) do

  enable_extension "plpgsql"

  # ── clients ────────────────────────────────────────────────────────
  create_table "clients", force: :cascade do |t|
    t.string   "email",                          null: false, default: ""
    t.string   "email_iv"
    t.string   "encrypted_password",             null: false, default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                  null: false, default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                null: false, default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "otp_secret"
    t.string   "otp_secret_iv"
    t.boolean  "otp_required_for_login",         null: false, default: false
    t.text     "otp_backup_codes"
    t.string   "otp_backup_codes_iv"
    t.boolean  "admin",                          null: false, default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false

    t.index ["email"],                unique: true
    t.index ["confirmation_token"],   unique: true
    t.index ["reset_password_token"], unique: true
    t.index ["unlock_token"],         unique: true
  end

  # ── channels ───────────────────────────────────────────────────────
  create_table "channels", force: :cascade do |t|
    t.bigint   "client_id",      null: false
    t.string   "title",          null: false
    t.string   "method",         null: false
    t.string   "provider",       null: false
    t.text     "credentials",    null: false
    t.string   "credentials_iv"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false

    t.index ["client_id"]
    t.index ["title"]
    t.index ["client_id", "title"]
    t.foreign_key "clients"
  end

  # ── templates ──────────────────────────────────────────────────────
  create_table "templates", force: :cascade do |t|
    t.bigint   "client_id",  null: false
    t.string   "title",      null: false
    t.string   "markup",     null: false, default: "html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

    t.index ["client_id"]
    t.index ["title"]
    t.index ["client_id", "title"]
    t.foreign_key "clients"
  end

  # ── template_versions ──────────────────────────────────────────────
  create_table "template_versions", force: :cascade do |t|
    t.bigint   "template_id", null: false
    t.string   "subject"
    t.text     "body",        null: false
    t.string   "lang",        null: false, default: "en"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false

    t.index ["template_id"]
    t.index ["template_id", "lang"], unique: true
    t.foreign_key "templates"
  end

  # ── projects ───────────────────────────────────────────────────────
  create_table "projects", force: :cascade do |t|
    t.bigint   "client_id",          null: false
    t.bigint   "channel_id",         null: false
    t.bigint   "template_id",        null: false
    t.string   "title",              null: false
    t.string   "public_key"
    t.string   "public_key_iv"
    t.string   "secret_key"
    t.string   "secret_key_iv"
    t.integer  "expiration_seconds", null: false, default: 60
    t.integer  "max_attempts",       null: false, default: 5
    t.string   "webhook_url"
    t.string   "webhook_url_iv"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false

    t.index ["client_id"]
    t.index ["channel_id"]
    t.index ["template_id"]
    t.index ["title"]
    t.index ["public_key"], unique: true
    t.index ["client_id", "title"]
    t.foreign_key "clients"
    t.foreign_key "channels"
    t.foreign_key "templates"
  end

  # ── users ──────────────────────────────────────────────────────────
  create_table "users", force: :cascade do |t|
    t.bigint   "project_id", null: false
    t.string   "uuid",       null: false
    t.string   "uuid_iv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

    t.index ["project_id"]
    t.index ["uuid"]
    t.index ["project_id", "uuid"], unique: true
    t.foreign_key "projects"
  end

  # ── verifications ──────────────────────────────────────────────────
  create_table "verifications", force: :cascade do |t|
    t.bigint   "user_id",              null: false
    t.string   "otp_code",             null: false
    t.string   "otp_code_iv"
    t.datetime "otp_sent_at",          null: false
    t.integer  "attempts",             null: false, default: 0
    t.text     "user_agent"
    t.string   "user_agent_iv"
    t.string   "ip_address"
    t.string   "ip_address_iv"
    t.string   "to",                   null: false
    t.string   "to_iv"
    t.string   "lang"
    t.boolean  "template_request",     null: false, default: false
    t.string   "delivery_identifier"
    t.string   "delivery_status",      null: false, default: "not-known"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false

    t.index ["user_id"]
    t.index ["otp_sent_at"]
    t.index ["delivery_status"]
    t.index ["user_id", "otp_sent_at"]
    t.foreign_key "users"
  end

  # ── logs ───────────────────────────────────────────────────────────
  create_table "logs", force: :cascade do |t|
    t.bigint   "client_id",  null: false
    t.bigint   "project_id", null: false
    t.bigint   "user_id",    null: false
    t.text     "message",    null: false
    t.string   "level",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

    t.index ["client_id"]
    t.index ["project_id"]
    t.index ["user_id"]
    t.index ["level"]
    t.index ["created_at"]
    t.index ["client_id", "created_at"]
    t.foreign_key "clients"
    t.foreign_key "projects"
    t.foreign_key "users"
  end

end
