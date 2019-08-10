ARG BASE

## Installing dependencies
FROM ${BASE} as composer

ARG MAGENTO_PUBLIC_KEY
ARG MAGENTO_PRIVATE_KEY

RUN composer config -g \
    http-basic.repo.magento.com \
    ${MAGENTO_PUBLIC_KEY} \
    ${MAGENTO_PRIVATE_KEY}

RUN composer create-project \
    --repository=https://repo.magento.com/ \
    magento/project-community-edition \
    /init

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

