class CreateTemplateVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :template_versions do |t|
      t.references :template, null: false, foreign_key: true
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
