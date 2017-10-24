#!/bin/bash

docker run -itd -p 80 \
    -v /mnt/volume-nyc1-01/web/corycollier.com/sites/default/files:/var/www/html/corycollier.com/sites/default/files \
    --restart="always" \
    --name="corycollier" \
    corycollier
