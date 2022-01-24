# Symfony 5.2 + PHP 8 + Mariadb sous docker

## Prérequis

Docker sur sa machine (Mac, Ubuntu, Windows) avec docker-compose (https://docs.docker.com/compose/install/)

I’ve create a repository for all the files we talked above https://gitlab.com/martinpham/symfony-5-docker

## Etape 1 : Arborescence du projet

```
project/
│
├── .env
├── docker-compose.yml
│
├── database/
│   ├── Dockerfile
│   └── data/
│
├── php-fpm/
│   └── Dockerfile
│
├── nginx/
│   ├── Dockerfile
│   └── nginx.conf
│
├── logs/
│   └── nginx/
│    	├── access.log
│   	└── error.log
│
├── symfony
│   ├── bin/
│   ├── config/
│   ├── public/
│   ├── src/
│   ├── var/
│   ├── vendor/
│   ├── data/
│   ├── .env
│   ├── .gitignore
│   ├── composer.json
│   ├── composer.lock
│   └── symfony.lock
```

## Etape 2 : Mariadb

```
nano project/database/Dockerfile

FROM mariadb:latest
CMD ["mysqld"]
EXPOSE 3306
```

## Etape 3 : php-fpm

```
nano project/php-fpm/Dockerfile

FROM php:fpm-alpine
COPY wait-for-it.sh /usr/bin/wait-for-it
RUN chmod +x /usr/bin/wait-for-it
RUN apk --update --no-cache add git
RUN docker-php-ext-install pdo_mysql
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /var/www
CMD composer install ; wait-for-it database:3306 -- bin/console doctrine:migrations:migrate ;  php-fpm 
EXPOSE 9000
```

## Etape 4: Nginx

```
nano project/nginx/Dockerfile

FROM nginx:alpine
WORKDIR /var/www
CMD ["nginx"]
EXPOSE 80
```

```
nano project/nginx/nginx.conf

user  nginx;
worker_processes  4;
daemon off;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    access_log  /var/log/nginx/access.log;
    sendfile        on;
    keepalive_timeout  65;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-available/*.conf;
}
```

```
nano project/nginx/sites/default.conf

upstream php-upstream {
    server php-fpm:9000;
}
```

```
nano project/nginx/conf.d/default.conf

server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    server_name localhost;
    root /var/www/public;
    index index.php index.html index.htm;

    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass php-upstream;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

## Etape 4 : Création du docker-compose et du .env

```
nano project/docker-compose.yml

version: '3'

services:
  database:
    build:
      context: ./database
    environment:
      - MYSQL_DATABASE=${DATABASE_NAME}
      - MYSQL_USER=${DATABASE_USER}
      - MYSQL_PASSWORD=${DATABASE_PASSWORD}
      - MYSQL_ROOT_PASSWORD=${DATABASE_ROOT_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql
      - ./database/data:/var/lib/mysql

  php-fpm:
    build:
      context: ./php-fpm
    depends_on:
      - database
    environment:
      - APP_ENV=${APP_ENV}
      - APP_SECRET=${APP_SECRET}
      - DATABASE_URL=mysql://${DATABASE_USER}:${DATABASE_PASSWORD}@database:3306/${DATABASE_NAME}?serverVersion=5.7
    volumes:
      - ../src:/var/www

  nginx:
    build:
      context: ./nginx
    volumes:
      - ../src:/var/www
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/sites/:/etc/nginx/sites-available
      - ./nginx/conf.d/:/etc/nginx/conf.d
      - ./logs:/var/log
    depends_on:
      - php-fpm
    ports:
      - "80:80"
```

```
nano project/.env

APP_ENV=dev
APP_SECRET=24e17c47430bd2044a61c131c1cf6990
DATABASE_NAME=symfony
DATABASE_USER=appuser
DATABASE_PASSWORD=apppassword
DATABASE_ROOT_PASSWORD=secret
```

```
symfony new app
```

```
docker-compose up -d --build
```

En ouvrant votre navigateur sur http://localhost/ vous devriez voir la homepage Symfony.
