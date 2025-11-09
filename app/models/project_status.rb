class ProjectStatus < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
