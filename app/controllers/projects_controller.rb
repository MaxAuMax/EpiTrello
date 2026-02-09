class ProjectsController < ApplicationController

    include ProjectsHelper

    def index
        @personal_projects = current_user.owned_projects.personal.includes(:project_status, :users)
        @team = current_user.active_team
        @team_projects = @team&.projects&.includes(:project_status, :users) || []
    end

    def show
        @project = Project.find(params[:id])
        @project_status = @project&.project_status&.name
        @project_users = @project.users
        @project_tasks = @project.tasks
    end

    def new
        @project = Project.new
        @status_options = status_options
        @is_team_project = params[:team_id].present?
        @team = @is_team_project ? Team.find(params[:team_id]) : nil
        
        # Check if user can create team project
        if @is_team_project && @team.owner_id != current_user.id
          flash[:alert] = "Only the team owner can create team projects."
          redirect_to teams_path
          return
        end
        
        # Check team project limit
        if @is_team_project && @team.projects.count >= 3
          flash[:alert] = "Team already has 3 projects (maximum allowed)."
          redirect_to @team
          return
        end
    end

    def create
        @project = Project.new(project_params)
        @project.owner = current_user
        
        # Handle team project
        if params[:project][:team_id].present?
          team = Team.find(params[:project][:team_id])
          if team.owner_id != current_user.id
            flash[:alert] = "Only the team owner can create team projects."
            redirect_to teams_path
            return
          end
          
          if team.projects.count >= 3
            flash[:alert] = "Team already has 3 projects (maximum allowed)."
            redirect_to team
            return
          end
          
          @project.team = team
          # Add all team members to the project
          team.users.each do |user|
            @project.users << user unless @project.users.include?(user)
          end
        else
          @project.users << current_user
        end

        @users = params[:project][:user_ids]
        @users&.delete_if { |user_id| user_id.empty? }

        if @users
            @users.each do |user_id|
                user = User.find(user_id)
                @project.users << user unless @project.users.include?(user)
            end
        end

        if @project.save
            if @project.team_id.present?
              redirect_to @project.team
            else
              redirect_to user_path(current_user)
            end
        else
            @status_options = status_options
            @is_team_project = @project.team_id.present?
            @team = @project.team
            render 'new'
        end
    end

    def edit
        @project = Project.find(params[:id])
    end

    def update
        @project = Project.find(params[:id])
        @project.update(project_params)
        redirect_to project_path(@project)
    end

    def destroy
        @project = Project.find(params[:id])
        team = @project.team
        @project.destroy
        
        if team
          redirect_to team
        else
          redirect_to user_path(current_user)
        end
    end

    private

    def project_params
        params.require(:project).permit(:name, :description, :start_date, :end_date, :project_status_id, :team_id, :user_ids => [], :lead_dev_ids => [])
    end
end
