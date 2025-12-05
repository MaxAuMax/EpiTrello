class TaskStatus < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
