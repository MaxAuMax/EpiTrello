class TeamUser < ApplicationRecord
  belongs_to :team
  belongs_to :user
  
  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected] }
  validates :user_id, uniqueness: { scope: :team_id, message: "is already in this team" }
  
  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :rejected, -> { where(status: 'rejected') }
end
