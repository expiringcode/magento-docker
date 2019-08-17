ARG BASE
ARG NODEV
FROM ${BASE} as composer

ARG MAGENTO_PUBLIC_KEY
ARG MAGENTO_PRIVATE_KEY

RUN composer config -g \
  http-basic.repo.magento.com \
  ${MAGENTO_PUBLIC_KEY} \
  ${MAGENTO_PRIVATE_KEY}

RUN composer create-project \
  ${NODEV} \
  --no-cache \
  --repository=https://repo.magento.com/ \
  magento/project-community-edition \
  /init

## Real image
FROM ${BASE}

ARG ENVIRONMENT
ENV ENVIRONMENT=${ENVIRONMENT}

USER www-data

COPY --chown=www-data:www-data --from=composer /init /init
COPY --chown=www-data:www-data --from=composer /root/.composer/auth.json ./auth.json

RUN cd /init && composer install --no-cache ${NODEV}

COPY --chown=www-data:www-data ./src/magento /init
RUN rm -rf ./auth.json
