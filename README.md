# corycollier.com

version 1.5.2

This site was written using [Silex](https://silex.symfony.com/) and [Parsedown](https://github.com/erusev/parsedown). The code is easily viewable on [GitHub](https://github.com/corycollier/corycollier.com). The gist of it is Silex intercepts the requests, and tries to find a markdown file matching the request. If it can't find one, an error page is displayed.

I don't host any front-end assets here. [Bootstrap](http://getbootstrap.com/), [Font Awesome](http://fontawesome.io/), and [jQuery](https://jquery.com/) are the UI tools of choice, and I see no need to host them myself.

This awesome background you see on my site - it's from [WallHaven](https://alpha.wallhaven.cc/wallpaper/487034).

There is no database to this site. All of the content comes from markdown files that are part of the repository.

I run it in production on [Docker](https://hub.docker.com/r/corycollier/apache-php/).

I've run [Wordpress](https://wordpress.org/) and [Drupal](https://www.drupal.org/) for a platform in the past. Both are great platforms. For me though, I found that being able to just write markdown makes my life a lot happier. So, I came up with this site one afternoon, and I try to make it accommodate what I need.
