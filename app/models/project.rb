class Project < ApplicationRecord

  has_many :projects_users, dependent: :destroy
  has_many :users, through: :projects_users
  has_many :tasks, dependent: :destroy
  has_many :tags, dependent: :destroy
  belongs_to :project_status
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :team, optional: true

  attr_accessor :user_ids
  
  validates :name, presence: true
  validate :team_project_limit
  
  scope :personal, -> { where(team_id: nil) }
  scope :team_projects, -> { where.not(team_id: nil) }
  
  private
  
  def team_project_limit
    if team_id.present? && team.present?
      if team.projects.where.not(id: id).count >= 3
        errors.add(:team, "already has 3 projects (maximum allowed)")
      end
    end
  end
end
