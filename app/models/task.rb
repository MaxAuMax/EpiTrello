class Task < ApplicationRecord

  validates :title, presence: true
  validates :task_status_id, presence: true

  belongs_to :project
  belongs_to :assignee, class_name: 'User', optional: true
  belongs_to :task_status

  has_many :comments, dependent: :destroy

end
