class TeamUsersController < ApplicationController
  before_action :set_team
  before_action :check_team_owner, only: [:create, :destroy]
  before_action :set_team_user, only: [:destroy, :accept, :reject]
  
  def create
    user = User.find(params[:user_id])
    
    if user.active_team.present?
      flash[:alert] = "#{user.username} is already in a team."
      redirect_to @team
      return
    end
    
    # Check if there's an existing invitation (including rejected ones)
    existing_invitation = @team.team_users.find_by(user: user)
    
    if existing_invitation
      # Update existing invitation to pending (allows re-inviting after rejection)
      existing_invitation.update(status: 'pending')
      flash[:notice] = "Invitation sent to #{user.username}!"
    else
      # Create new invitation
      team_user = @team.team_users.build(user: user, status: 'pending')
      
      if team_user.save
        flash[:notice] = "Invitation sent to #{user.username}!"
      else
        flash[:alert] = "Failed to send invitation: #{team_user.errors.full_messages.join(', ')}"
      end
    end
    
    redirect_to @team
  end

  def destroy
    @team_user.destroy
    flash[:notice] = "Member removed from team."
    redirect_to @team
  end

  def accept
    unless @team_user.user_id == current_user.id
      flash[:alert] = "You can only accept your own invitations."
      redirect_to root_path
      return
    end
    
    if current_user.active_team.present? && current_user.active_team != @team
      flash[:alert] = "You are already in another team. Leave it first."
      redirect_to root_path
      return
    end
    
    @team_user.update(status: 'accepted')
    flash[:notice] = "You have joined #{@team.name}!"
    redirect_to @team
  end

  def reject
    unless @team_user.user_id == current_user.id
      flash[:alert] = "You can only reject your own invitations."
      redirect_to root_path
      return
    end
    
    @team_user.update(status: 'rejected')
    flash[:notice] = "You have rejected the invitation."
    redirect_to root_path
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_team_user
    @team_user = TeamUser.find(params[:id])
  end

  def check_team_owner
    unless @team.owner_id == current_user.id
      flash[:alert] = "Only the team owner can perform this action."
      redirect_to @team
    end
  end
end
