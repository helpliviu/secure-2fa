class CreateVerifications < ActiveRecord::Migration[8.0]
  def change
    create_table :verifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :otp_code
      t.string :otp_code_iv

      t.timestamps
    end
  end
end
