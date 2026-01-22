class TaskStatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task_status, only: [:edit, :update, :destroy]

  def new
    @task_status = TaskStatus.new
  end

  def create
    @task_status = TaskStatus.new(task_status_params)
    @task_status.position = TaskStatus.maximum(:position).to_i + 1

    if @task_status.save
      redirect_back fallback_location: root_path, notice: 'Column created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task_status.update(task_status_params)
      redirect_back fallback_location: root_path, notice: 'Column updated successfully.'
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

  private

  def set_task_status
    @task_status = TaskStatus.find(params[:id])
  end

  def task_status_params
    params.require(:task_status).permit(:name, :description, :position)
  end
end
