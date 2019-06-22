ARG BASE
ARG ENVIRONMENT

FROM php:7.2-alpine as composer

COPY ./src/magento/package.json /init/package.json

RUN composer install -o

FROM ${BASE}

ENV ENVIRONMENT=${ENVIRONMENT}

USER www-data

COPY --from=composer /init /init
COPY ./src/magento /init

## Commands
ENTRYPOINT ["entrypoint"]
CMD ["php-fpm"]

