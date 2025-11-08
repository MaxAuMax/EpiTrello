class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :projects_users
  has_many :projects, through: :projects_users
end
