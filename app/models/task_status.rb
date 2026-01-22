class TaskStatus < ApplicationRecord
  has_many :tasks, dependent: :restrict_with_error
  
  COLORS = %w[gray red orange yellow green blue purple pink].freeze
  
  validates :name, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :color, presence: true, inclusion: { in: COLORS }
  
  default_scope { order(position: :asc) }
end
