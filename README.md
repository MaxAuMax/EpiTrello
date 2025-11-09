# EpiTrello
Epitrello is a project wich aim to reproduce the project management app **Trello** with the ✨​ *Epitech touch* ✨​.

# Installation
Everything is contained in docker so you must have docker (docker compose) installed on your system.

Before all, you need to know that everything is contained in docker and here are some useful informations:

- The databases service is named "db" in ***docker-compose.yml*** and the container name is "mariadb". Is also running on port 3307 and need an [environment file](#here-an-example-of-env-file) (.env).

- The rails app service is named "web" and its container name is **"epitrello-web"** and running from **port 3000**. It is build from the [Dockerfile](./Dockerfile) wich contain the image, configuration, installations and others things necessary to run the app.

## Real start

Now you know everything you have to, so we can start !

In this folder, run this command:
```
docker compose up -d; docker attach epitrello-web
```

Aaaaaand that's all !

What ? Are you sad ? You really thought that installation would be harder ?

Surprise ! It is not x)

The ruby image of the docker is "slim" and should not take more than 1Go on your system.

For any questions or issues contact jeremy.calosso-merlino@epitech.eu

---

#### here an example of .env file:
```
DATABASE_HOST=mariadb
DATABASE_NAME=epitrello
DATABASE_USER=<YourUsername>
DATABASE_PASSWORD=<YourPassword>
RAILS_ENV=development

MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=epitrello
MYSQL_USER=<YourUsername>
MYSQL_PASSWORD=<YourPassword>
```

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
### Generate sample values
```
docker compose exec web bin/rails db:seed
```