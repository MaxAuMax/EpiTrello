class CreateTasks < ActiveRecord::Migration[8.0]
  def change

    unless table_exists?(:task_statuses)
      create_table :task_statuses do |t|
        t.string :name, null: false
        t.text :description
        t.timestamps
      end
    end

    unless table_exists?(:tasks)
      create_table :tasks do |t|
        t.string :title
        t.text :description
        t.date :due_date
        t.timestamps
      end

      add_reference :tasks, :project, null: false, foreign_key: true, type: :bigint
      add_reference :tasks, :task_status, null: false, foreign_key: true
      add_reference :tasks, :assignee, foreign_key: { to_table: :users }, type: :bigint
    end
  end
end
