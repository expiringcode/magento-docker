ARG BASE
FROM ${BASE}

WORKDIR $WORKDIR

RUN chown -R www-data:www-data $WORKDIR

USER root

COPY ./src/magento .

ENTRYPOINT ["entrypoint"]
CMD ["php-fpm"]