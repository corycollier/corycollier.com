# Base Image and Credits
FROM php:7-apache
MAINTAINER Cory Collier <corycollier@corycollier.com>

RUN apt-get -y update
RUN apt-get -y install \
    wget \
    git \
    vim

# PHP Configuration updates
RUN echo "date.timezone = 'America/New_York'" >> /etc/php.ini

# Add Drupal nginx config
ADD config/httpd.conf /etc/apache2/sites-enabled/000-default.conf

RUN echo "Listen 80" >> /etc/apache2/ports.conf

RUN a2enmod rewrite headers

# Add files to the running image
ADD . /var/www/html/corycollier.com

ADD config/.vimrc /root/.vimrc
ADD config/.bashrc /root/.bashrc

WORKDIR /var/www/html/corycollier.com/

RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php -- --quiet
RUN php -dmemory_limit=-1 -n composer.phar install --no-dev -vvv
