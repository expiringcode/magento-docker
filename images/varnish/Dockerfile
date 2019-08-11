FROM varnish:latest

COPY images/varnish/default.vcl /etc/varnish/default.vcl

## Healthcheck | Entrypoint
COPY images/nginx/docker-healthcheck /usr/local/bin

RUN chmod +x /usr/local/bin/docker-healthcheck

HEALTHCHECK --interval=10s --timeout=3s \
  CMD ["docker-healthcheck"]
