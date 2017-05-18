FROM pdedkov/debian-php-base:latest
MAINTAINER Pavel E. Dedkov <pavel.dedkov@gmail.com>

# configure php
RUN sed -i "/^listen /c listen = 0.0.0.0:9000" /etc/php/7.0/fpm/pool.d/www.conf \ 
&& sed -i "s/;daemonize = yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf

# configure app
RUN mkdir /var/www && chown www-data:www-data /var/www

EXPOSE 9000

ENTRYPOINT ["php-fpm7.0"]
