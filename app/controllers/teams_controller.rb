class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :check_team_owner, only: [:edit, :update, :destroy]
  
  def index
    @teams = Team.all
  end

  def new
    if current_user.active_team.present?
      flash[:alert] = "You are already in a team. Leave your current team first."
      redirect_to teams_path
      return
    end
    
    @team = Team.new
    @all_users = User.where.not(id: current_user.id)
  end

  def create
    if current_user.active_team.present?
      flash[:alert] = "You are already in a team. Leave your current team first."
      redirect_to teams_path
      return
    end
    
    @team = Team.new(team_params)
    @team.owner = current_user

    if @team.save
      # Auto-accept owner as member
      TeamUser.create!(team: @team, user: current_user, status: 'accepted')
      flash[:notice] = "Team created successfully!"
      redirect_to @team
    else
      @all_users = User.where.not(id: current_user.id)
      render 'new'
    end
  end

  def show
    @team_members = @team.accepted_members.includes(:user)
    @pending_invitations = @team.pending_invitations.includes(:user)
    @team_projects = @team.projects.includes(:project_status, :users).order(:name)
    # Exclude only accepted and pending users, but allow re-inviting rejected users
    excluded_user_ids = @team.team_users.where(status: ['accepted', 'pending']).pluck(:user_id) + [@team.owner_id]
    @all_users = User.where.not(id: excluded_user_ids).order(:username)
  end

  def edit
    # Exclude only accepted and pending users, but allow re-inviting rejected users
    excluded_user_ids = @team.team_users.where(status: ['accepted', 'pending']).pluck(:user_id) + [@team.owner_id]
    @all_users = User.where.not(id: excluded_user_ids)
  end

  def update
    if @team.update(team_params)
      flash[:notice] = "Team updated successfully!"
      redirect_to @team
    else
      @all_users = User.where.not(id: [@team.users.pluck(:id), @team.owner_id].flatten)
      render 'edit'
    end
  end

  def destroy
    @team.destroy
    flash[:notice] = "Team deleted successfully!"
    redirect_to root_path
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def check_team_owner
    unless @team.owner_id == current_user.id
      flash[:alert] = "Only the team owner can perform this action."
      redirect_to @team
    end
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
