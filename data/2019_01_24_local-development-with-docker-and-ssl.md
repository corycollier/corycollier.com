
<div class="col-md-12">

## Local Development With Docker and SSL
> <small class="text-muted">January 24, 2019</small>

> Even local web development is being forced to use SSL these days. Well, there's no sense in fighting the times. It's time to figure out how to create local SSL certs to serve your local dev sites.

So, lately I've had to do development on a number of different sites for a number of different reasons. Mimicking environments for all these sites on a single machine is completely impossible without Docker. Modern browsers *require* SSL on sites, even localhost sites. So, I was forced to figure out how to serve all of my stuff through SSL and use Docker to mimic the various environments for each site.

First, get Docker installed. That's a tutorial beyond the scope of this one. The [main docker site](https://www.docker.com/) has plenty of documentation to get you started. I'll leave it to you to start there.

Next, create a local folder to hold all of your local SSL keys, certs, csrs, etc. I'm on a mac, and I use ~/Certificates. That path will show up a bit later. Just substitute that path with whatever path you're using for your certificate path.

Next, let's spin up [Jason Wilder's Awesome Nginx Proxy Container](https://github.com/jwilder/nginx-proxy). I use this with an additional volume mount for mounting local certificates into the main certificate folder for nginx on the container. Here's how I run it:

```
docker run -d -p 80:80 -p 443:443 \
    -v ~/Certificates:/etc/nginx/certs \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    --restart="always" \
    --name="nginx-proxy" \
    jwilder/nginx-proxy
```

So, now we'll need to create a local CA which cane be trusted by our machine for subsequent SSL certs. [Brad Touesnard has an excellent tutorial on this](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/). I'll paraphase that tutorial with the following set of commands:

```
cd ~/Certificates
openssl genrsa -des3 -out corycollier.ca.key 2048
openssl req -x509 -new -nodes -key corycollier.ca.key -sha256 -days 1825 -out corycollier.ca.pem
```

You'll get a series of CLI prompts. Answer them. Next, set your browser to Always Trust your newly created CA pem file (mine is corycollier.ca.pem).

Now, we need to create SSL certs for a local site. A hack I've always found useful with sites is to add an A record for dev.domain.name (where domain.name can be any .com domain you're working with) to 127.0.0.1. That kind of public DNS means you won't have to do any local /etc/hosts file modifications. If that's not an option, set your hosts file accordingly.

We need a Subject Alternative Name extension. Use the following as an example:
```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = dev.corycollier.com
DNS.2 = dev.corycollier.com.192.168.1.19.xip.io
```

For the actual SSL info (again, referencing Brad Touesnard's tutorial), we paraphrase:
```
cd ~/Certificates
openssl genrsa -out dev.corycollier.com.key 2048
openssl req -new -key dev.corycollier.com.key -out dev.corycollier.com.csr
openssl x509 -req -in dev.corycollier.com.csr -CA corycollier.ca.pem -CAkey corycollier.ca.key -CAcreateserial -out dev.corycollier.com.crt -days 1825 -sha256 -extfile dev.corycollier.com.ext
```

Finally, we spin up a container using a volume mount for the code and a VIRTUAL_HOST flag to specify the domain name (the nginx proxy requires this to work). Short version:

```
docker run -itd -P \
    -e VIRTUAL_HOST=dev.corycollier.com \
    -v ~/Repositories/corycollier.com:/var/www/html \
    --name corycollier.com \
    corycollier/apache-php:7.2.x-dev
```

And that *should* do it. 

</div>
