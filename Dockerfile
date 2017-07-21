# Base Image and Credits
FROM drupal
MAINTAINER Cory Collier <corycollier@corycollier.com>

RUN apt-get -y update
RUN apt-get -y install \
    wget \
    git \
    vim


# PHP Configuration updates
RUN echo "date.timezone = 'America/New_York'" >> /etc/php.ini

# Add Drupal nginx config
ADD apache.conf /etc/apache2/sites-enabled/000-default.conf

RUN echo "Listen 8000" >> /etc/apache2/ports.conf

# Add files to the running image
ADD . /var/www/html/corycollier.com

WORKDIR /var/www/html/corycollier.com/

RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php -- --quiet
RUN php -dmemory_limit=-1 -n composer.phar install --no-dev -vvv

docker run -it -d -p 80 \
--restart="always" --name="corycollier" \
-v /mnt/volume-nyc1-01/web/corycollier.com/sites/default/files/:/var/www/html/corycollier.com/web/sites/default/files \
-v /mnt/volume-nyc1-01/web/corycollier.com/sites/default/settings.php:/var/www/html/corycollier.com/web/sites/default/settings.php \
--link mysql:mysql \
corycollier/web
