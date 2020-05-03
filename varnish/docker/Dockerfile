FROM varnish:6.0

COPY ./varnish/config/default.vcl /etc/varnish/default.vcl

## Healthcheck | Entrypoint
RUN apt-get update && \
    apt-get install -y wget
COPY ./varnish/docker/docker-healthcheck /usr/local/bin

RUN chmod +x /usr/local/bin/docker-healthcheck

# HEALTHCHECK --interval=10s --timeout=3s \
#   CMD ["docker-healthcheck"]
