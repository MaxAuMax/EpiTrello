class CreateProjectsUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :projects_users do |t|
      t.belongs_to :project
      t.belongs_to :user
      t.timestamps
    end
  end
end
