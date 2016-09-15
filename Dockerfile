# Base Image and Credits
FROM drupal
MAINTAINER Cory Collier <corycollier@corycollier.com>

#PHP Configuration updates
RUN echo "date.timezone = 'America/New_York'" >> /etc/php.ini

# Add Drupal nginx config
ADD apache.conf /etc/apache2/sites-enabled/000-default.conf

#add files to the running image
ADD . /var/www/html/corycollier.com

WORKDIR /var/www/html/corycollier.com/web