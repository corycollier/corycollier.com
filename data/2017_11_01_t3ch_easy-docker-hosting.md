<div class="col-md-12">
# Easy Docker Hosting

There's a lot to be said about containerizing websites and applications. Much smarter people than I have made the case for it. If you're considering docker for hosting, here's how I host this site:

## What You'll Need:
* A server you can SSH into ([DigitalOcean is a great host](https://m.do.co/c/dfef8bd401d2))
* Docker
* Your code
* git

First, install Docker. Here's a [good tutorial on how to install Docker on Ubuntu 16](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04). I'm not going into the numerous ways to get Dockkr installed on your specific environment. Use Google.

Next, setup a place for you to host your code on that machine. We'll use this in a bit. For now, just checkout your code somewhere on your home folder (You're using git, right?). I do this like so:
```
git clone https://github.com/corycollier/corycollier.com.git ~/sites/corycollier.com
```

Once you've got your code somewhere, you can start up a docker container running your site, with your local code volume mounted into the container. I use the following setup:
```
docker run -itd \
    -v /home/corycollier/sites/corycollier.com:/var/www/html \
    -p 8000:80 \
    --restart="always" \
    --name="corycollier.com" \
    corycollier/apache-php:0.1.0
```

I'm basically volume mounting my code into my apache web server. You'll notice the image name that I'm using is a [docker container of my own](https://github.com/corycollier/docker-apache-php). That container sets `/var/www/html/web` as the docroot. That reflects how my code actually works.

Something else to notice, I map port 8000 to port 80. Apache thinks it's running production, but I stick nginx on the front of everything, to reduce load to apache. Old habits die hard I guess.

Finally, I use a poor-man's version of automatic deployments:
Crontab with a private key to git pull master every hour.

```
* */1 * * * su -s /bin/sh nobody -c 'cd ~/sites/corycollier.com && /usr/bin/git pull origin master'
```

That's pretty much it. I don't use a database for this site, so I don't have to do any database updates when I deploy code. Filesystem and caching handles all the rest of it.
</div>
