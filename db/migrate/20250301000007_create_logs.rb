class CreateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :logs do |t|
      t.references :client,  null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :user,    null: false, foreign_key: true

      t.text   :message, null: false
      t.string :level,   null: false

      t.timestamps
    end

    add_index :logs, :level
    add_index :logs, :created_at
    add_index :logs, [:client_id, :created_at]
  end
end
