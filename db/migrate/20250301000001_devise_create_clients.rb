class DeviseCreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :email_iv
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at

      ## Two-factor authenticatable (devise-two-factor)
      t.string  :otp_secret
      t.string  :otp_secret_iv
      t.boolean :otp_required_for_login, default: false, null: false
      t.text    :otp_backup_codes
      t.string  :otp_backup_codes_iv

      ## Custom fields
      t.boolean :admin, default: false, null: false

      t.timestamps null: false
    end

    add_index :clients, :email,                unique: true
    add_index :clients, :reset_password_token, unique: true
    add_index :clients, :confirmation_token,   unique: true
    add_index :clients, :unlock_token,         unique: true
  end
end
