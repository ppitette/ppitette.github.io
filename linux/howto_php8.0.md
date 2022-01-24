# Installation de PHP 8.0

## Ajouter le dépot SURY PHP PPA
```
sudo apt -y install lsb-release apt-transport-https ca-certificates
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update
```

## Installation de PHP (nginx)

```
sudo apt install php8.0 php8.0-fpm php8.0-curl php8.0-gd php8.0-intl php8.0-mbstring php8.0-cgi php8.0-mysql php8.0-sqlite3 php8.0-xml php8.0-zip (php-common, php8.0-cli, php8.0-common, php8.0-opcache, php8.0-readline)
sudo apt install redis-server php8.0-redis php8.0-amqp (php8.0-igbinary)
```

