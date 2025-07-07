class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.references :project, null: false, foreign_key: true
      t.string :uuid
      t.string :uuid_iv

      t.timestamps
    end
  end
end
