# EpiTrello
Epitrello is a project wich aim to reproduce the project management app **Trello** with the ✨​ *Epitech touch* ✨​.
# Installation
Everything is contained in docker so you must have docker (docker compose) installed on your system.

To run the project, just follow this [documentation](./epitrello/README.md)

# Useful commands
Here you will find all commands that could be useful !
### Install new gem (dependancy)
put it in Gemfile and execute this command (docker must be launched):
```
docker compose exec epitrello-web bundle install
```
### Create migration
```
docker compose exec epitrello-web bin/rails g migration <YourMigrationName>
```
### Visualise routes
```
docker run epitrello-web bin/rails routes
```