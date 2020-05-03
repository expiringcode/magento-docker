FROM php:7.2-fpm-alpine as composer

RUN set -xe && curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer

FROM php:7.2-fpm-alpine

## HEALTHCHECK
RUN apk add --update --no-cache \
  fcgi

HEALTHCHECK --interval=10s --timeout=3s \
  CMD \
  SCRIPT_NAME=/ping \
  SCRIPT_FILENAME=/ping \
  REQUEST_METHOD=GET \
  cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1

## Adding Magento dependencies
RUN apk add --update --no-cache \
  git \
  busybox-suid \
  imagemagick \
  libxml2-dev \
  icu \
  make \
  zlib-dev \
  icu-dev \
  g++ \
  libxslt-dev \
  libpng \
  libpng-dev \
  freetype \
  freetype-dev \
  jpeg-dev \
  libjpeg \
  libjpeg-turbo \
  libjpeg-turbo-dev \
  libmemcached-libs

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS imagemagick-dev libtool \
  && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
  && pecl install imagick-3.4.3 \
  && docker-php-ext-enable imagick \
  && apk add --no-cache --virtual .imagick-runtime-deps imagemagick \
  && apk del .phpize-deps

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
  && apk add --no-cache --update --virtual .memcached-deps zlib-dev cyrus-sasl-dev libmemcached-dev \
  && pecl install memcached \
  && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
  && rm -rf /tmp/* \
  && apk del .memcached-deps .phpize-deps

RUN docker-php-ext-configure intl

RUN docker-php-ext-configure gd \
  --with-freetype-dir=/usr/lib/ \
  --with-png-dir=/usr/lib/ \
  --with-jpeg-dir=/usr/lib/ \
  --with-gd

RUN docker-php-ext-install \
  mysqli \
  pdo_mysql \
  gd \
  bcmath \
  intl \
  soap \
  xsl \
  zip \
  opcache

RUN docker-php-ext-enable \
  mysqli \
  pdo_mysql \
  gd \
  bcmath \
  intl \
  soap \
  xsl \
  zip \
  opcache

##  WORKDIR
ENV WORKDIR /www
WORKDIR $WORKDIR
RUN chown -R www-data:www-data $WORKDIR

## Composer
COPY --from=composer /usr/local/bin/composer /usr/local/bin/composer
COPY ./docker/utils/wait-for.sh /usr/local/bin/wait-for

RUN chmod +x /usr/local/bin/wait-for
RUN mkdir -p /init
RUN chown -R www-data:www-data /init

## PHP Conf
COPY ./backend_magento/magento/docker/conf/* /usr/local/etc/php/conf.d/
