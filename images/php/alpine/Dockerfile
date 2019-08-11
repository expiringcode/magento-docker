ARG BASE

## Real container
FROM ${BASE}

ARG ENVIRONMENT
ENV ENVIRONMENT=${ENVIRONMENT}

ARG MAGENTO_PUBLIC_KEY
ARG MAGENTO_PRIVATE_KEY

USER www-data

RUN composer config -g \
  http-basic.repo.magento.com \
  ${MAGENTO_PUBLIC_KEY} \
  ${MAGENTO_PRIVATE_KEY}

RUN composer create-project \
  --repository=https://repo.magento.com/ \
  magento/project-community-edition \
  /init

# Removing keys
RUN rm /home/www-data/.composer/auth.json

COPY --chown=www-data:www-data ./src/magento /init

## Commands
ENTRYPOINT ["entrypoint"]
CMD ["php-fpm"]

