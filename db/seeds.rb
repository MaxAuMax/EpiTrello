# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Créer les statuts de projet par défaut
ProjectStatus.find_or_create_by(name: 'Not Started') do |status|
  status.description = 'The project has not yet started.'
end

ProjectStatus.find_or_create_by(name: 'In Progress') do |status|
  status.description = 'The project is currently in progress.'
end

ProjectStatus.find_or_create_by(name: 'Completed') do |status|
  status.description = 'The project has been completed.'
end

ProjectStatus.find_or_create_by(name: 'On Hold') do |status|
  status.description = 'The project is currently on hold.'
end

# Créer les statuts de tâche par défaut
TaskStatus.find_or_create_by(name: 'To Do') do |status|
  status.description = 'The task is yet to be started.'
end

TaskStatus.find_or_create_by(name: 'In Progress') do |status|
  status.description = 'The task is currently being worked on.'
end

TaskStatus.find_or_create_by(name: 'Completed') do |status|
  status.description = 'The task has been completed.'
end

TaskStatus.find_or_create_by(name: 'On Hold') do |status|
  status.description = 'The task is currently on hold.'
end
