# exemples docker-compose

## docker 01

```yaml
version: '3'

services:
    db:
        image: mariadb
        container_name: guestbook_db
        restart: always
        ports:
            - 3306:3306
        environment:
            MYSQL_ROOT_PASSWORD: root
            MYSQL_DATABASE: guestbook
            MYSQL_USER: guestbook
            MYSQL_PASSWORD: pwdguest
    adminer:
        image: adminer
        container_name: guestbook_adm
        restart: always
        ports:
            - 8080:8080
#    rabbitmq:
#        image: rabbitmq:3.7-management
#        container_name: guestbook_rabbit
#        ports: [5672, 15672]
    mailer:
        image: schickling/mailcatcher
        container_name: guestbook_mailer
        ports: [1025, 1080]

```

## docker 02

```yaml
version: "3.8"

services:
    db:
        image: mariadb:10.3
        container_name: hnde_db
        restart: always
        volumes:
            - db-data:/var/lib/mysql
            - ./docker/dev/my.cnf:/etc/mysql/conf.d/my.cnf
        environment:
            MYSQL_ROOT_PASSWORD: notSecureChangeMe
        networks:
            - hnde_dev

    phpmyadmin:
        image: phpmyadmin:5.1-fpm
        container_name: hnde_phpmyadmin
        restart: always
        depends_on:
            - db
        environment:
            PMA_HOST: db
        networks:
            - hnde_dev
        ports:
            - 8080:80

    maildev:
        image: maildev/maildev
        container_name: hnde_maildev
        restart: always
        command: bin/maildev --web 80 --smtp 25 --hide-extensions STARTTLS
        ports:
            - 8080:80
        networks:
            - hnde_dev

    redis:
        image: redis:6.2.0-buster
        container_name: hnde_redis
        networks:
            - hnde_dev

    app:
        build: docker/dev
        container_name: hnde_www
        restart: always
        depends_on:
            - db
            - redis
        volumes:
            - ./:/app
        ports:
            - 8741:80
        networks:
            - hnde_dev

networks:
    hnde_dev:

volumes:
    db-data:

```

## docker 03

```yaml
version: "3.8"

services:
    db:
        image: mariadb
        container_name: symfony_db
        volumes:
            - db-data:/var/lib/mysql
        environment:
            MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
            MYSQL_DATABASE: ${MYSQL_DATABASE}
            MYSQL_USER: ${MYSQL_USER}
            MYSQL_PASSWORD: ${MYSQL_PASSWORD}
        restart: always
        networks:
            - dev
    php:
        build:
            context: php7-fpm
            args:
                TIMEZONE: ${TIMEZONE}
        container_name: symfony_php
        ports:
            - 9000:9000
        volumes:
            - ${SYMFONY_APP_PATH}:/var/www/symfony
            - ./logs/symfony:/var/www/symfony/app/logs
        restart: always
        networks:
            - dev
    www:
        build: nginx
        container_name: symfony_www
        ports:
            - 8080:80
        volumes:
            - ./logs/nginx/:/var/log/nginx
        networks:
            - dev
    maildev:
        image: maildev/maildev
        container_name: symfony_maildev
        command: bin/maildev --web 80 --smtp 25 --hide-extensions STARTTLS
        ports:
          - "8081:80"
        restart: always
        networks:
            - dev
    # elk:
    #    image: willdurand/elk
    #    container_name: symfony_elk
    #    ports:
    #        - 81:80
    #    volumes:
    #        - ./elk/logstash:/etc/logstash
    #        - ./elk/logstash/patterns:/opt/logstash/patterns
    #    volumes_from:
    #        - php
    #        - nginx
    #    networks:
    #        - dev

networks:
    dev:

volumes:
    db-data:

```
