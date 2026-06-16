class CreateChannels < ActiveRecord::Migration[7.1]
  def change
    create_table :channels do |t|
      t.references :client,      null: false, foreign_key: true
      t.string     :title,       null: false
      t.string     :method,      null: false
      t.string     :provider,    null: false
      t.text       :credentials, null: false
      t.string     :credentials_iv

      t.timestamps
    end

    add_index :channels, :title
    add_index :channels, [:client_id, :title]
  end
end
