# Run the project
Here you will find instructions to run the project.

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

The ruby image of the docker is "slim" and should not take more than 1Go on your system. Now you can use the project and [here](../README.md) you will find some useful commands to dev and win some precious seconds.

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