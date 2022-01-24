# Serveur Web (Nginx)

## installation

```
sudo apt install nginx
```

puis lancer le serveur :
```
sudo service nginx start
```

## Test
Depuis un navigateur => http://adresse_serveur/ ==> Affichage de la page Nginx par défaut

## Configuration
```
sudo nano /etc/nginx/nginx.conf
================================================================================
user www-data;
worker_processes 1;

error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log  main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;

    #gzip on;

    include /etc/nginx/conf.d/*.conf;
}
================================================================================
```


Créer le fichier de configuration propre au site.

```
vim /etc/nginx/conf.d/hnde.conf
==========================================================================
server {
    listen 80;
    server_name hnde.lan;

    root /home/hnde/www;
    index index.html;

    error_log /home/hnde/logs/error.log;
    access_log /home/hnde/logs/access.log;

    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }

    location / {
        try_files $uri $uri/ $uri.html =404;
    }

    error_page 404 500 501 /404.html;
}

server {
    listen 80;
    server_name www.hnde.lan;
    return 301 http://hnde.lan$request_uri;
}
==========================================================================
```

### configuration

Modifier le fichier de configuration propre au site.

```
vim /etc/nginx/conf.d/hnde.conf
==========================================================================
server {
    listen 80;
    server_name hnde.lan;

    root /home/hnde/www;
    index index.html;

    error_log /home/hnde/logs/error.log;
    access_log /home/hnde/logs/access.log;

    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }

    location / {
        try_files $uri $uri/ $uri.html =404;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        include fastcgi_params;
    }

    error_page 404 500 501 /404.html;
}

server {
    listen 80;
    server_name www.hnde.lan;
    location / {
        if ($http_host ~* "^www.hnde.lan$") {
            rewrite ^(.*)$ http://hnde.lan/$1 redirect;
        }
    }
}
==========================================================================
```

### Composer

```
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo php -r "unlink('composer-setup.php');"
```

[Test]
------

```
composer --version
==========================================================================
Composer version 1.9.0 2019-08-02 20:55:32
==========================================================================
```

### Symfony

(renommer l'ancien répertoire www en old)

```
composer create-project symfony/website-skeleton www
```

Modifier le fichier de configuration propre au site.

```
vim /etc/nginx/conf.d/hnde.conf
==========================================================================
server {
    server_name hnde.lan www.hnde.lan;
    root /home/hnde/www/public;

    location / {
        # try to serve file directly, fallback to index.php
        try_files $uri /index.php$is_args$args;
    }

    location ~ ^/index\.php(/|$) {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;

        # optionally set the value of the environment variables used in the application
        # fastcgi_param APP_ENV prod;
        # fastcgi_param APP_SECRET <app-secret-id>;
        # fastcgi_param DATABASE_URL "mysql://db_user:db_pass@host:3306/db_name";

        # When you are using symlinks to link the document root to the
        # current version of your application, you should pass the real
        # application path instead of the path to the symlink to PHP
        # FPM.
        # Otherwise, PHP's OPcache may not properly detect changes to
        # your PHP files (see https://github.com/zendtech/ZendOptimizerPlus/issues/126
        # for more information).
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        # Prevents URIs that include the front controller. This will 404:
        # http://domain.tld/index.php/some-path
        # Remove the internal directive to allow URIs like this
        internal;
    }

    # return 404 for all other php files not matching the front controller
    # this prevents access to other php files you don't want to be accessible.
    location ~ \.php$ {
        return 404;
    }

    error_log /home/hnde/logs/error.log;
    access_log /home/hnde/logs/access.log;
}
==========================================================================
```



sudo systemctl start php7.4-fpm.service && ps --no-headers -o "rss,cmd" -C php-fpm7.4 | awk '{ sum+=$1 } END { printf ("%d%s\n", sum/NR/1024,"M") }'