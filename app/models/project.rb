class Project < ApplicationRecord

  has_many :projects_users, dependent: :destroy
  has_many :users, through: :projects_users
  has_many :tasks, dependent: :destroy
  has_many :tags, dependent: :destroy
  belongs_to :project_status

  attr_accessor :user_ids

end
