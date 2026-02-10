class CreateTags < ActiveRecord::Migration[8.0]
    def change
        unless table_exists?(:tags)
            create_table :tags do |t|
                t.references :project, null: false, foreign_key: true
                t.string :name, null: false
                t.string :color, default: '#808080'

                t.timestamps
            end
        end

        unless table_exists?(:tags_tasks)
            create_table :tags_tasks, id: false do |t|
                t.references :task, null: false, foreign_key: true
                t.references :tag, null: false, foreign_key: true
            end
        end

        add_index :tags_tasks, [:task_id, :tag_id], unique: true
        add_index :tags, [:project_id, :name], unique: true
    end
end
