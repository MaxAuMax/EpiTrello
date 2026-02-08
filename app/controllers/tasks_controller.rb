class TasksController < ApplicationController

    before_action :authenticate_user!
    before_action :set_project, except: [:update_status]
    before_action :set_task, only: [:show, :edit, :update, :destroy, :delete, :update_status]
    before_action :load_status_options, only: [:new, :edit, :create, :update]

    def index
        @tasks = @project.tasks
    end

    def show
        @project = Project.find(params[:project_id])
        @task = @project.tasks.find(params[:id])
        @comments = @task.comments.includes(:user).order(created_at: :asc)
        render layout: false
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
            respond_to do |format|
                format.html { redirect_to project_path(@project), notice: 'Task was successfully created.' }
                format.turbo_stream { redirect_to project_path(@project), status: :see_other }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.turbo_stream { render turbo_stream: turbo_stream.replace("new_task_form", partial: "tasks/form", locals: { task: @task, project: @project }) }
            end
        end
    end

    def edit
        render layout: false
    end

    def update
        if @task.update(task_params)
            respond_to do |format|
                format.html { redirect_to project_path(@project), notice: 'Task was successfully updated.' }
                format.turbo_stream { redirect_to project_path(@project), status: :see_other }
            end
        else
            render :edit, layout: false
        end
    end

    def delete
        render layout: false
    end

    def destroy
        @task.destroy
        redirect_to project_path(@project), notice: 'Task was successfully deleted.'
    end

    def update_status
        if @task.update(task_status_id: params[:task_status_id])
            head :ok
        else
            head :unprocessable_entity
        end
    end

    private

    def set_project
        @project = Project.find(params[:project_id]) if params[:project_id]
    end

    def set_task
        if params[:project_id]
            @task = @project.tasks.find(params[:id])
        else
            @task = Task.find(params[:id])
        end
    end

    def task_params
        params.require(:task).permit(:title, :description, :due_date, :task_status_id, :assignee_id)
    end

    def load_status_options
        @status_options = TaskStatus.all.map { |status| [status.name, status.id] }
    end

end
