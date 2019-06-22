ARG BASE
ARG ENVIRONMENT

FROM ${BASE}

COPY ./config/${ENVIRONMENT}/vhost.conf /etc/nginx/sites-enabled/vhost.conf

ENTRYPOINT entrypoint