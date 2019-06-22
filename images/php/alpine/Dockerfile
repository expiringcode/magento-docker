ARG BASE
ARG ENVIRONMENT

FROM ${BASE}

ENV ENVIRONMENT=${ENVIRONMENT}

USER www-data

COPY ./src/magento /init

## Commands
ENTRYPOINT ["entrypoint"]
CMD ["php-fpm"]

