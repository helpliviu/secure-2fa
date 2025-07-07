class CreateChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :channels do |t|
      t.references :client, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
