class TaskStatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task_status, only: [:edit, :update, :destroy, :move]

  def new
    @task_status = TaskStatus.new
  end

  def create
    @task_status = TaskStatus.new(task_status_params)
    max_position = TaskStatus.maximum(:position) || 0
    @task_status.position = max_position + 1

    if @task_status.save
      if params[:project_id].present?
        redirect_to project_path(params[:project_id]), notice: 'Column created successfully.'
      else
        redirect_back fallback_location: root_path, notice: 'Column created successfully.'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    render partial: 'task_statuses/edit_modal', locals: { task_status: @task_status }
  end

  def update
    if @task_status.update(task_status_params)
      if params[:project_id].present?
        redirect_to project_path(params[:project_id]), notice: 'Column updated successfully.'
      else
        redirect_to request.referer || root_path, notice: 'Column updated successfully.'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @task_status.tasks.any?
      redirect_back fallback_location: root_path, alert: 'Cannot delete column with tasks.'
    else
      @task_status.destroy
      redirect_back fallback_location: root_path, notice: 'Column deleted successfully.'
    end
  end

  def move
    new_position = params[:position].to_i
    old_position = @task_status.position
    
    TaskStatus.transaction do
      if new_position < old_position
        # Moving left - shift columns right
        TaskStatus.where('position >= ? AND position < ?', new_position, old_position)
                  .update_all('position = position + 1')
      elsif new_position > old_position
        # Moving right - shift columns left
        TaskStatus.where('position > ? AND position <= ?', old_position, new_position)
                  .update_all('position = position - 1')
      end
      
      @task_status.update_column(:position, new_position)
    end
    
    head :ok
  rescue => e
    Rails.logger.error("Failed to move column: #{e.message}")
    head :unprocessable_entity
  end

  private

  def set_task_status
    @task_status = TaskStatus.find(params[:id])
  end

  def task_status_params
    params.require(:task_status).permit(:name, :description, :position, :color)
  end
end
