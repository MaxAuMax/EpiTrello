class AddColorToTaskStatuses < ActiveRecord::Migration[8.0]
  def change
    add_column :task_statuses, :color, :string, default: 'gray', null: false
  end
end
