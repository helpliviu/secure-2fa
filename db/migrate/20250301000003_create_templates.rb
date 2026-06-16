class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.references :client, null: false, foreign_key: true
      t.string     :title,  null: false
      t.string     :markup, null: false, default: "html"

      t.timestamps
    end

    add_index :templates, :title
    add_index :templates, [:client_id, :title]

    create_table :template_versions do |t|
      t.references :template, null: false, foreign_key: true
      t.string     :subject
      t.text       :body,    null: false
      t.string     :lang,    null: false, default: "en"

      t.timestamps
    end

    add_index :template_versions, [:template_id, :lang], unique: true
  end
end
