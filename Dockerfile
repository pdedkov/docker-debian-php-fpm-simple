FROM pdedkov/debian-php-base:latest
MAINTAINER Pavel E. Dedkov <pavel.dedkov@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \ 
&& apt-get dist-upgrade -y \
&& apt-get install -y --no-install-recommends php${PHP_VERSION}-fpm \
&& apt-get autoclean \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# configure php
RUN sed -i "/;date.timezone /c date.timezone = ${TIMEZONE}" $PHP_DIR/fpm/php.ini \
&& sed -i "/^short_open_tag /c short_open_tag = On" $PHP_DIR/fpm/php.ini \
&& sed -i "/^listen /c listen = 0.0.0.0:9000" $PHP_DIR/fpm/pool.d/www.conf \ 
&& sed -i "s/;daemonize = yes/daemonize = no/g" $PHP_DIR/fpm/php-fpm.conf

# configure app
RUN mkdir /var/www && mkdir -p /run/php/ && chown www-data:www-data /var/www /run/php
EXPOSE 9000

ENTRYPOINT ["php-fpm7.1"]

