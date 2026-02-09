class AddTeamAndOwnerToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :team_id, :bigint
    add_column :projects, :owner_id, :bigint
    
    # Set owner_id for existing projects to the first user associated with the project
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE projects p
          LEFT JOIN projects_users pu ON p.id = pu.project_id
          SET p.owner_id = pu.user_id
          WHERE p.owner_id IS NULL
          ORDER BY pu.created_at ASC
          LIMIT 1
        SQL
        
        # For any projects still without an owner, set to first user in system
        execute <<-SQL
          UPDATE projects p
          SET p.owner_id = (SELECT id FROM users ORDER BY id LIMIT 1)
          WHERE p.owner_id IS NULL
        SQL
        
        change_column_null :projects, :owner_id, false
      end
    end
    
    add_index :projects, :team_id
    add_index :projects, :owner_id
    add_foreign_key :projects, :teams, column: :team_id
    add_foreign_key :projects, :users, column: :owner_id
  end
end
