class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.references :client,   null: false, foreign_key: true
      t.references :channel,  null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true

      t.string  :title,              null: false
      t.string  :public_key
      t.string  :public_key_iv
      t.string  :secret_key
      t.string  :secret_key_iv
      t.integer :expiration_seconds, null: false, default: 60
      t.integer :max_attempts,       null: false, default: 5
      t.string  :webhook_url
      t.string  :webhook_url_iv

      t.timestamps
    end

    add_index :projects, :title
    add_index :projects, :public_key, unique: true
    add_index :projects, [:client_id, :title]
  end
end
