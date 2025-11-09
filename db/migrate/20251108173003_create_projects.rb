class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.references :project_status, foreign_key: true
      t.timestamps
    end
  end
end
