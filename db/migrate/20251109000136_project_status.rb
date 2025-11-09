class ProjectStatus < ActiveRecord::Migration[8.0]
  def change
    create_table :project_statuses do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
