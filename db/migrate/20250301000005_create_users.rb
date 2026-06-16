class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.references :project, null: false, foreign_key: true
      t.string     :uuid,    null: false
      t.string     :uuid_iv

      t.timestamps
    end

    add_index :users, :uuid
    add_index :users, [:project_id, :uuid], unique: true
  end
end
