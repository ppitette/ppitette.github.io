# Symfony 5.2 + PHP 8 sous docker

## Prérequis

Docker sur sa machine (Mac, Ubuntu, Windows) avec docker-compose (https://docs.docker.com/compose/install/)

## Etape 1: Création de l’arborescence du projet

L’idée est de séparer la partie “infrastructure” que représente le sous ensemble (Nginx, PHP8 et Docker) de la partie applicative qui est Symfony.

On commence par créer l'arborescence dont on va avoir besoin pour notre projet.

```
mkdir ~/demo-symfony-php8 && cd ~/demo-symfony-php8
mkdir infra && mkdir infra/php && mkdir infra/nginx && mkdir infra/logs && mkdir infra/logs/nginx
mkdir symfony
```

Si tout se passe bien, à la fin du tuto vous devriez vous retrouver avec l’arborescence suivante

```
demo-symfony-php8
│
├── infra/
│   ├── logs/
│   │   └── nginx/
│   │       ├── access.log
│   │       └── error.log
│   ├── nginx/
│   │   ├── Dockerfile
│   │   └── nginx.conf
│   ├── php/
│   │   ├── Dockerfile
│   ├── .env
│   ├── docker-compose.yml
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

## Etape 2: PHP 8

On se place dans le répertoire infra/php pour créer le Dockerfile.
Il a pour but de faire tourner un container sur sur dernière version de PHP8.
On y ajoute composer, qui va nous permettre de récupérer Symfony plus tard.

```
cd ~/demo-symfony-php8/infra/php 
vim Dockerfile
-----
FROM php:8.0.2-fpm-alpine
RUN apk --update --no-cache add git
RUN docker-php-ext-install pdo_mysql
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /var/www
CMD composer install ; php-fpm
EXPOSE 9000
-----
```

## Etape 3: Nginx

On se place ensuite dans le repertoire infra/nginx pour y configurer notre serveur à l’aide des 2 fichiers:

Le Dockerfile pour faire tourner Nginx sur sa version Alpine

```
cd ~/demo-symfony-php8/infra/nginx
vim Dockerfile
-----
FROM nginx:alpine
WORKDIR /var/www
CMD ["nginx"]
EXPOSE 80
-----
```

Le fichier nginx.conf pour configurer notre serveur Nginx

```
vim nginx.conf
-----
user nginx;
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
            fastcgi_pass php-fpm:9000;
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
}
-----
```

## Etape 4: Création du docker-compose et du .env

On se place dans le répertoire “infra” et on crée le fichier .env pour ajouter quelques variables d’environnement que l’on utilisera avec docker-compose pour configurer Symfony.

```
cd ~/demo-symfony-php8/infra
vim .env
-----
APP_FOLDER=../symfony
APP_ENV=dev
APP_SECRET=24e17c47430bd2044a61c131c1cf6990
-----
```

On crée ensuite le fichier docker-compose.yml, pour réunir et configurer nos 2 containers.

```
vim docker-compose.yml
-----
version: '3'

services:
    php:
        container_name: "php-fpm"
        build:
            context: ./php
        environment:
            - APP_ENV=${APP_ENV}
            - APP_SECRET=${APP_SECRET}
        volumes:
            - ${APP_FOLDER}:/var/www

    nginx:
        container_name: "nginx"
        build:
            context: ./nginx
        volumes:
            - ${APP_FOLDER}:/var/www
            - ./nginx/nginx.conf:/etc/nginx/nginx.conf
            - ./logs:/var/log
        depends_on:
            - php
        ports:
            - "80:80"
-----
```

A ce stade, il ne nous reste plus qu’à construire nos images et tout lancer en executant la commande suivante depuis le répertoire infra.

```
docker-compose up -d --build
```

Si tout se passe bien, à la fin vous devriez avoir 2 containers en cours d’execution.

## Etape 5: Symfony 5

Récupérerons maintenant les sources du projet Symfony.
Souvenez-vous, dans la configuration du container php du fichier docker-compose.yml, nous avons partagé le volume pour que le repertoire symfony de notre projet pointe dans /var/www du container php.

Composer étant installé sur ce container, il ne reste plus qu’à lancer la commande suivante à l’interieur du container PHP pour installer Symfony dans sa version 5.2 supportant PHP8.

```
docker-compose run php composer create-project symfony/website-skeleton:"5.2." .
```

et voila ! En ouvrant votre navigateur sur http://localhost/ vous devriez voir la homepage Symfony.

