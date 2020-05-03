# Magento 2.X 🛍

The project aims to be production ready and provides all the services needed for a Magento deployment. These services are also configured automatically so once they are up and running it will be working out of the box.

## Services

This setup is based on docker and includes the following services:

- mysql
- elasticsearch
- redis
- php: 3 replicas with 3 different functions
  - php-fpm
  - magento cron
  - setup container, dies after setup
- nginx
- varnish

Only Varnish is exposed.

## Requirements

- Docker
- Reverse proxy

-

The reverse proxy is used to handle multiple projects at the same time on the same computer or server. In case of a development environment you can spin up multiple projects and access them through a domain name instead of a port.

To avoid this, map port 80 on Varnish container with the host.

I'm using [blimpair/loadbalancer](https://github.com/blimpair/loadbalancer) which adds dnsmasq locally and resolves all `.test` domains. It is fully automated and needs no manual setup.

## Development

To start development you just need to clone the project and run the following command:

```sh
cmd/dev.sh
```

The command above accepts the same parameters that you'd give `docker-compose up` such as `-d` to daemonize the process, container names to start up just a set of containers and so on.

There also exist other useful commands such as:

- `cmd/compose.sh` same as docker-compsoe but uses the yml files necessary
- `cmd/clean.sh` same as above but brings down the project and cleans volumes

> **Tip**: to launch commands inside the container such as bin/magento run the following `/cmd/magento.sh <args>`

## Deploy

Inserire la variabile **n2_env** per la CI in Gitlab copiando al suo interno tutte le variabili presenti nel tuo **.env** in locale.

Per mettere un progetto online ti basterà inviare un commit.
Una pipeline di CI partirà automaticamente.

## Contributions

> TODO:

## Issues template

> TODO:
