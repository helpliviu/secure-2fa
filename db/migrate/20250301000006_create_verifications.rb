class CreateVerifications < ActiveRecord::Migration[7.1]
  def change
    create_table :verifications do |t|
      t.references :user,                null: false, foreign_key: true

      t.string   :otp_code,             null: false
      t.string   :otp_code_iv
      t.datetime :otp_sent_at,          null: false
      t.integer  :attempts,             null: false, default: 0

      t.text     :user_agent
      t.string   :user_agent_iv
      t.string   :ip_address
      t.string   :ip_address_iv

      t.string   :to,                   null: false
      t.string   :to_iv
      t.string   :lang
      t.boolean  :template_request,     null: false, default: false

      t.string   :delivery_identifier
      t.string   :delivery_status,      null: false, default: "not-known"

      t.timestamps
    end

    add_index :verifications, :otp_sent_at
    add_index :verifications, :delivery_status
    add_index :verifications, [:user_id, :otp_sent_at]
  end
end
