ARG BASE

## Installing dependencies
FROM ${BASE} as composer

COPY ./src/magento/composer.json /init/composer.json

# RUN composer install --no-scripts --no-autoloader --no-progress --no-suggest --no-dev -d /init
# RUN composer create-project --repository=https://repo.magento.com/ magento/project-community-edition /init

## Real container
FROM ${BASE}

ARG ENVIRONMENT
ENV ENVIRONMENT=${ENVIRONMENT}

USER www-data

COPY --from=composer /init /init
COPY ./src/magento /init

# RUN composer dump-autoload --optimize -d /init

## Commands
ENTRYPOINT ["entrypoint"]
CMD ["php-fpm"]

