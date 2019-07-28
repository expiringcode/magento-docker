ARG BASE
FROM ${BASE}

ARG ENVIRONMENT
ENV ENVIRONMENT=${ENVIRONMENT}

COPY ./config/${ENVIRONMENT}/vhost.conf /etc/nginx/sites-enabled/vhost.conf

ENTRYPOINT entrypoint