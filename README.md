# magento-docker
A docker-compose setup of Magento.

## Description

This is supposed to be a stack of all the services needed to use Magento at it's full potential making use of all the cache layers suggested by the documentation.

Recently I had the need to work on Magento and I didn't find any setup that was complete enough. So after closing the feature I needed to develop, I decided to create this system that was helpful both in development and production environments. Also it is intended to give an idea on what are the different components that should be used to make Magento as fast as possible.

I've tried to put it all together and make it as simple and as ready for production use as possible following the best practices of Docker.

## Requirements

The solution puts together the following technologies

- Docker
- Docker-compose

- php
- mysql
- nginx
- redis
- varnish
- elasticsearch

You should have basic understanding of the first two as the project relies heavily on the two technologies.

### Software LB

For local development or if deploying using Docker-Machine, check out [this repo](https://github.com/blimpair/loadbalancer) which simplifies Load Balancing and works perfectly in a local environment along with [GasMask](https://github.com/2ndalpha/gasmask)

## Getting started

You must have Docker and docker-compose installed on your system.

To work on the project follow these steps. (Check out the requirements Software LB section)

1. Clone the project
2. Copy `.env.sample` to `.env` and configure it to reflect your settings
3. Go to the config folder
   1. In `php.env` update `VIRTUAL_HOST` to match your desired hostname
   2. You can leave the rest as it is
4. Launch `sh bin/dev.sh up` so docker-compose can run all the containers and start the project

At this point, as it is the first time the project is being launched, all the Docker images will be built. It may take some time.

The Docker images that will be built are the following:

- phplibs: extends the default php image and adds all the necessary extensions for Magento
- php: extends `phplibs` and pulls Magento from `composer`. It will be initialized in `/init`
- MySQL: simply adds whatever is in `$ENVIRONMENT/sql-init` to the image in order to initialize it however you want.
- varnish: adds the default configuration for Magento.
- nginx: adds some default configuration files for Magento.
- redis: which adds a configuration file although it's empty but it's there to make it easy to customize. It works out of the box nonetheless.

All the images above are configured also to have a health-check for docker. Thus running on your machine `docker ps -a` you'll see if the container is *healthy* or not.

### Containers

The containers that are run with docker-compose are more than the images. That's because there are different instances of the same Docker image in some cases. And Elasticsearch is added which doesn't need to be built.

### AWS

If you're deploying to AWS, you should comment out all the services which can be replaced by AWS services

1. Redis can be replaced by **ElastiCache**
2. Varnish can be replaced to some extent by **CloudFront**
3. MySQL can be replaced by **RDS**
4. PHP and Nginx remain (so you can add them to an **EC2** configured with **Docker-Machine**) although you shouldn't use other software load balancers.
5. You can add **ALB/ELB** to the stack for Load Balancing.
6. **Route53** instead if you want to handle DNS from AWS

### Docker-machine

TODO:

## /init

As for the nature of PHP, it needs to be coupled with a webserver. I prefer Nginx. The downside of this one is that the two need to share the code.

There are different solutions for this (when it comes to docker):

1. It is possible to copy the code on both images
2. It is possible to copy the code in one image and on startup have it copy the code to a shared volume.

It is **not** an elegant solution, having both PHP and Nginx on the same image managed by `Supervisord` and it should be avoided at all costs.

I chose the second solution as I don't like replicating code because it can lead to problems due to unsynced code. So what happens is that during build time, the source code inside `src/magento` is copied to `/init` in the **php** image. On runtime, it is expected that **php** and **nginx** share a volume which is mounted to `/www`. Another instance of php which also has the volume, starts up using a different `entrypoint`. This entrypoint makes sure to copy the code to the volume and initializes Magento by launching the `setup:install` script with all the necessary arguments to initialize Magento and connect it to the other services.

So the startup-script does the following:

1. Copies the code from `/init` to `/www` (which is the shared volume with nginx)
2. The copying happens only on Production or in development if `src/magento` is empty. That's because if it is not empty, it shouldn't overwrite the content of `src/magento` because it may contain user changes
3. Generates composer autoload files (optimized)
4. Launches `setup:install` so that you don't have to manually configure the database
5. Configures **Redis** for *session management*, for *default caching* and for *full-page caching*.
6. Tells Magento that **Varnish** is configured
7. Sets `deploy:mode` to **developer** or **production** accordingly
8. Exits

At this point the containers `php` and `nginx` have both the fully functional code.

## TODO

[ ] Configure nginx

[x] What happens if magento-setup is run twice

[ ] Configure gitlab-ci and possibly other CI/CD tools

[ ] Convert docker-compose to Kubernetes

[ ] Work on making setup faster

[ ] Finish Docker-Machine section
