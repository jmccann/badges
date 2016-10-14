# Badges
This application allows you to generate and cache badges for all sorts of statuses you may want for your `README.md`.  It allows you to update the badge while maintaining a static URL for your `README.md`.

# Endpoints

## GET /badges
Get a list of all badges

## GET /badges/< owner >
Get a list of all badges for a specific owner

## GET /badges/< owner >/< project >/< name >
Get details on a specific badge

## POST /badges/< owner >/< project >/< name >
Create a new badge

## PUT /badges/< owner >/< project >/< name >
Update a badge **TBD**

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
