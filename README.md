# corycollier.com

[![Build Status](https://travis-ci.org/corycollier/corycollier.com.svg?branch=develop)](https://travis-ci.org/corycollier/corycollier.com)

My public website.

## Deployment

docker run -it -d -p 80 \
    --restart="always" --name="corycollier" \
    -v /mnt/volume-nyc1-01/web/corycollier.com/sites/default/files/:/var/www/html/corycollier.com/web/sites/default/files \
    -v /mnt/volume-nyc1-01/web/corycollier.com/sites/default/settings.php:/var/www/html/corycollier.com/web/sites/default/settings.php \
    --link mysql:mysql \
    corycollier/web
