# Polls App

This is the django polls tutorial app written in docker: https://docs.djangoproject.com/en/3.2/intro/tutorial01/#

Similarly you can use the Docker django guide for inspiration for how you might setup a docker project like this: https://docs.docker.com/samples/django/

This repo follows this guide but uses a different environment to set it up.

## Quickstart

This will skip the tutorial and just use the code already present in this repo. If you would like to use this for learning Django and performing the tutorial complete the changes mentioned in differences below. For now, here's just how to spin up the app:

```
make build
make up
# Then in another window
$ make shell
root@8a4b1e1effb0:/src# ./manage.py runserver 0.0.0.0
```

Now you can open your browser to `localhost:8000`

## Differences

Many design decisions here follow the idea of microservice architecture. I try to use environment variables for some of the secret configuration and I chose to use a postgresDB instead of sqlite. As such there is some extra config and changes.

If you are choosing to use this environment to learn using the tutorial, read the instructions below.Check your work in the `full diff` section. After everything is removed, you can:

```
$ make build
$ make up
# Then in another window
$ make shell
root@8a4b1e1effb0:/src# cd /opt
root@8a4b1e1effb0:/opt# django-admin startproject mysite
root@8a4b1e1effb0:/opt# cp -r mysite/* /src
root@8a4b1e1effb0:/opt# rm -rf /opt
# Now inside the container, proceed to step 2 of part 1, Goodluck!:
```

We do this `/opt` -> `/src` shuffle because of the image `WORKDIR`, and reparent the directory. After this all the steps should be the same.

### Docker

The environment uses docker to build everything. If you are coming in here to follow the tutorial, delete the code already here. As you will be running this from scratch.

```
$ rm -rf django
```

With that done you can initialize the Django project with

```
make build
```

Followed by a

```
make shell
```

In the docker shell you can then run any arbitrary commands that will come up in the tutorial, such as starting the webserver or migrations:

```
root@8a4b1e1effb0:/src# ./manage.py runserver 0.0.0.0:8000
```

From outside of this docker shell you can then hit your browser at `localhost:8000`. Additionally you will actually do your code work outside the container. All changes to the `django/` directory are instantly populated.

### PostgresDB

I am using a database, when you hit the DB step in part 2 "Database setup" this will be your DB block:
* `django/mysite/settings.py`

``` diff
+ import os
[... Later in file ...]
- DATABASES = {
-     'default': {
-         'ENGINE': 'django.db.backends.sqlite3',
-         'NAME': BASE_DIR / 'db.sqlite3',
-     }
- }
+ DATABASES = {
+     'default': {
+         'ENGINE': 'django.db.backends.postgresql',
+         'NAME': os.environ.get('POSTGRES_DB'),
+         'PASSWORD':os.environ.get('POSTGRES_PASSWORD'),
+         'USER': os.environ.get('POSTGRES_USER'),
+         'HOST': os.environ.get('POSTGRES_HOST', 'polls_db'),
+         'PORT': 5432,
+     }
+ }
```

* `database/Dockerfile`

``` diff
- ADD init-db.sql /docker-entrypoint-initdb.d/init-db.sql
```

Remove the `init-db.sql` entrypoint file if you're planning to do the tutorial from scratch.

## Productionize

_Coming soon_

How would we run this on kube how would we serve static files with nginx?
