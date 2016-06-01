FROM debian:latest
MAINTAINER Pavel E. Dedkov <pavel.dedkov@gmail.com>

# env
ENV TIMEZONE Europe/Moscow

# install required software
RUN apt-get update \ 
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends ca-certificates php5-fpm php5-curl php5-redis php5-mysql php5-mcrypt php5-gearman php5-mongo php-gettext php5-readline php5-tidy \
&& apt-get autoclean \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# configure php
RUN sed -i "/;date.timezone /c date.timezone = ${TIMEZONE}/" /etc/php5/fpm/php.ini \
&& sed -i "/^short_open_tag /c short_open_tag = On" /etc/php5/fpm/php.ini \
&& sed -i "/^listen /c listen = 0.0.0.0:9000" /etc/php5/fpm/pool.d/www.conf \ 
&& sed -i "s/;daemonize = yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

# configure app
RUN mkdir /var/www && chown www-data:www-data /var/www

EXPOSE 9000

ENTRYPOINT ["php5-fpm"]
