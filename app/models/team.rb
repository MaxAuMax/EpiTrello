class Team < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users
  has_many :projects, dependent: :nullify
  
  validates :name, presence: true
  validate :max_projects_limit
  
  def accepted_members
    team_users.where(status: 'accepted')
  end
  
  def pending_invitations
    team_users.where(status: 'pending')
  end
  
  private
  
  def max_projects_limit
    if projects.count >= 3
      errors.add(:projects, "cannot exceed 3 projects per team")
    end
  end
end
