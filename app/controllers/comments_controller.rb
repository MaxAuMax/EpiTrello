class CommentsController < ApplicationController
    before_action :set_project
    before_action :set_task

    def create
        @comment = @task.comments.build(comment_params)
        @comment.user = current_user

        if @comment.save
            redirect_to project_path(@project), notice: 'Comment added successfully.'
        else
            redirect_to project_path(@project), alert: 'Failed to add comment.'
        end
    end

    def destroy
        @comment = @task.comments.find(params[:id])
        if @comment.destroy
            redirect_to project_task_path(@project, @task), notice: 'Comment deleted successfully.'
        else
            redirect_to project_task_path(@project, @task), alert: 'Failed to delete comment.'
        end
    end

    private

    def set_project
        @project = Project.find(params[:project_id])
    end

    def set_task
        @task = @project.tasks.find(params[:task_id])
    end

    def comment_params
        params.require(:comment).permit(:content)
    end
end