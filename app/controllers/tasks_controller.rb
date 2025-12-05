class TasksController < ApplicationController

    before_action :authenticate_user!
    before_action :set_project
    before_action :set_task, only: [:show, :edit, :update, :destroy]
    before_action :load_status_options, only: [:new, :edit, :create, :update]

    def index
        @tasks = @project.tasks
    end

    def show
    end

    def new
        @task = @project.tasks.build
        statuses = TaskStatus.all
        @task_statuses = statuses.map { |status| [status.name, status.id] }
        assignees = @project.users
        @assignee_options = assignees.map { |user| [user.username, user.id] }
    end

    def create
        @task = @project.tasks.build(task_params)
        if @task.save
            redirect_to project_tasks_path(@project), notice: 'Task was successfully created.'
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @task.update(task_params)
            redirect_to project_task_path(@project, @task), notice: 'Task was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        @task.destroy
        redirect_to project_tasks_path(@project), notice: 'Task was successfully deleted.'
    end

    private

    def set_project
        @project = Project.find(params[:project_id])
    end

    def set_task
        @task = @project.tasks.find(params[:id])
    end

    def task_params
        params.require(:task).permit(:title, :description, :due_date, :task_status_id, :assignee_id)
    end

    def load_status_options
        @status_options = TaskStatus.all.map { |status| [status.name, status.id] }
    end

end
