ARG NODEV
ARG BASE

FROM ${BASE} as composer

ARG MAGENTO_PUBLIC_KEY
ARG MAGENTO_PRIVATE_KEY
# ENV COMPOSER_VENDOR_DIR=/vendor
# ENV COMPOSER_ALLOW_SUPERUSER=1

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
# ENV COMPOSER_VENDOR_DIR=/vendor

# USER www-data

# --chown=www-data:www-data
COPY --from=composer /init /init
# --chown=www-data:www-data
# COPY --from=composer ${COMPOSER_VENDOR_DIR} ${COMPOSER_VENDOR_DIR}
# --chown=www-data:www-data
COPY --from=composer /root/.composer/auth.json ./auth.json

# RUN cd /init && composer install --no-cache ${NODEV}

# --chown=www-data:www-data
COPY ./backend_magento/magento/app /init
RUN rm -rf ./auth.json

# Entrypoint
COPY ./backend_magento/magento/docker/init/* /usr/local/bin/
RUN chmod -R +x /usr/local/bin/

ENTRYPOINT [ "custom-entrypoint" ]
CMD ["php-fpm"]
