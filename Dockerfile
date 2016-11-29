FROM debian:latest
MAINTAINER Pavel E. Dedkov <pavel.dedkov@gmail.com>

# env
ENV TIMEZONE Europe/Moscow

RUN apt-get update && apt-get install -y wget && echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list && wget https://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg && rm -f dotdeb.gpg

# install required software
RUN apt-get update \ 
&& apt-get dist-upgrade -y \
&& apt-get install -y --no-install-recommends ca-certificates php7.0-fpm php7.0-curl php7.0-redis php7.0-mysql php7.0-sqlite3 php7.0-mongodb php7.0-readline php7.0-tidy  php7.0-intl \
&& apt-get autoclean \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# configure php
RUN sed -i "/;date.timezone /c date.timezone = ${TIMEZONE}" /etc/php/7.0/fpm/php.ini \
&& sed -i "/^short_open_tag /c short_open_tag = On" /etc/php/7.0/fpm/php.ini \
&& sed -i "/^listen /c listen = 0.0.0.0:9000" /etc/php/7.0/fpm/pool.d/www.conf \ 
&& sed -i "s/;daemonize = yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf

# configure app
RUN mkdir /var/www && chown www-data:www-data /var/www

EXPOSE 9000

ENTRYPOINT ["php-fpm7.0"]
