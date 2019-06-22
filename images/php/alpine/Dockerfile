ARG BASE
FROM ${BASE}

USER www-data

COPY ./src/magento /init

## Commands
ENTRYPOINT ["entrypoint"]
CMD ["php-fpm"]

