class Tag < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :tasks

  validates :name, presence: true
  validates :name, uniqueness: { scope: :project_id, message: "existe déjà pour ce projet" }
  validates :color, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/, message: "doit être un code couleur hexadécimal valide" }, allow_blank: true

  before_validation :set_default_color

  private

  def set_default_color
    self.color ||= '#808080'
  end
end
