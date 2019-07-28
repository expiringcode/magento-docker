FROM alpine as ssl

ARG OPENSSL_SUBJ="/C=IT/ST=Parma/L=Parma/O=Caffeina/OU=IT Department/CN=caffeina.com"
ENV OPENSSL_SUBJ=${OPENSSL_SUBJ}

## Adding self-signed SSL for localhost https
RUN apk update && apk add openssl && \
	mkdir -p /etc/nginx/cert && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/cert/nginx.key \
	-out /etc/nginx/cert/nginx.crt \
	-subj "${OPENSSL_SUBJ}" && \
	openssl dhparam 2048 -out /etc/nginx/cert/dhparam.pem

FROM nginx:alpine

RUN apk update && apk add --no-cache --virtual .build-deps \
	wget

## WORKDIR
ENV WORKDIR /www
WORKDIR $WORKDIR

## Conf | SSL
COPY --from=ssl /etc/nginx/cert /etc/nginx/cert
COPY images/nginx/conf /etc/nginx

## Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

## Healthcheck | Entrypoint
COPY images/nginx/entrypoint /usr/bin
COPY images/nginx/docker-healthcheck /usr/local/bin

RUN chmod +x /usr/bin/entrypoint \
	&& chmod +x /usr/local/bin/docker-healthcheck \
	&& mkdir -p $WORKDIR/nginx \
	&& rm -Rf /etc/nginx

HEALTHCHECK --interval=10s --timeout=3s \
	CMD ["docker-healthcheck"]