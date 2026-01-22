class AddPositionToTaskStatuses < ActiveRecord::Migration[8.0]
  def change
    add_column :task_statuses, :position, :integer, default: 0
    add_index :task_statuses, :position
    
    # Set position for existing statuses
    reversible do |dir|
      dir.up do
        TaskStatus.order(:id).each_with_index do |status, index|
          status.update_column(:position, index)
        end
      end
    end
  end
end
