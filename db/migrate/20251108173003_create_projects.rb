class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:project_statuses)
      create_table :project_statuses do |t|
        t.string :name, null: false
        t.text :description

        t.timestamps
      end
    end

    unless table_exists?(:projects)
      create_table :projects do |t|
        t.string :name
        t.string :description
        t.references :project_status, foreign_key: true
        t.timestamps
      end
    end
  end
end
