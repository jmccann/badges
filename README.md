# Badges
This application allows you to generate and cache badges for all sorts of statuses you may want for your `README.md`.  It allows you to update the badge while maintaining a static URL for your `README.md`.

# Database

## SQLite

Badges uses an embedded SQLite as the default database with zero configuration required. Override the default SQLite database configuration use the following environment variables:

```
DATABASE_DRIVER=sqlite3
DATABASE_CONFIG=/var/lib/drone/drone.sqlite
```

## Postgres

Configure a Postgres database backend:

```
DATABASE_DRIVER=postgres
DATABASE_CONFIG=postgres://root:pa55word@127.0.0.1:5432/badges
```

See the official [postgres connection string documentation](https://www.postgresql.org/docs/current/static/libpq-connect.html#LIBPQ-CONNSTRING) for a complete set of configuration options and examples.

# Endpoints

## GET /badges
Get a list of all badges

## GET /badges/< owner >
Get a list of all badges for a specific owner

## GET /badges/< owner >/< project >/< name >
Get details on a specific badge

## GET /badges/< owner >/< project >/< name >/badge.svg
Get SVG image of a badge

## POST /badges/< owner >/< project >/< name >
Create a new badge

### JSON Data
* subject - (defaults to `name`) What you want to track the value/status for
* color - The color of the badge
* status - The value/status of the subject

Visit https://shields.io towards the bottom at **Your Badge** for an idea of configuration options.

Sample post data:
```
{
  "color":"green",
  "status":"passing"
}

{
  "subject":"coverage",
  "color":"red",
  "status":"21%"
}
```

## PUT /badges/< owner >/< project >/< name >
Update an existing badge or create a new one if one doesn't exist

### JSON data
* subject - (defaults to `name`) What you want to track the value/status for
* color - The color of the badge
* status - The value/status of the subject

Visit https://shields.io towards the bottom at **Your Badge** for an idea of configuration options.

Sample post data:
```
{
  "color":"green",
  "status":"passing"
}

{
  "subject":"coverage",
  "color":"red",
  "status":"21%"
}
```

## DELETE /badges/< owner >/< project >/< name >
Delete a badge

# Contributing
Contributions, questions, and comments are welcomed and encouraged.

Please open an [Issue](https://github.com/jmccann/badges/issues/new) with any problems you run into or questions you may have.

Please open a [Pull Request](https://github.com/jmccann/badges/compare) with any fixes/enhancements you'd like to contribute.

# Testing
Run locally by [installing Docker](https://www.docker.com/products/overview#/install_the_platform) and the [Drone CLI](http://readme.drone.io/0.5/reference/cli/overview/).  Then run:

```
drone exec
```

This will run the testing inside a docker container.
