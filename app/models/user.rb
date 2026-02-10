class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :projects_users, dependent: :destroy
  has_many :projects, through: :projects_users
  has_many :owned_projects, class_name: 'Project', foreign_key: 'owner_id', dependent: :destroy
  
  has_one :owned_team, class_name: 'Team', foreign_key: 'owner_id', dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :teams, through: :team_users

  validates :username, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.email.split('@').first # Génère un nom d'utilisateur depuis l'email
    end
  end
  
  # Get the user's active team (either owned or accepted membership)
  def active_team
    owned_team || teams.joins(:team_users).where(team_users: { status: 'accepted' }).first
  end
  
  # Check if user can join a team
  def can_join_team?
    active_team.nil?
  end
  
  # Get pending team invitations
  def pending_team_invitations
    team_users.pending
  end
end
