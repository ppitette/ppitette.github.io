# Installation de PHP 8.1

## Ajouter le dépot SURY PHP PPA
```
sudo apt -y install lsb-release apt-transport-https ca-certificates
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update
```

## Installation de PHP (nginx)

```
sudo apt install php8.1 php8.1-fpm php8.1-curl php8.1-gd php8.1-intl php8.1-mbstring php8.1-cgi php8.1-mysql php8.1-sqlite3 php8.1-xml php8.1-zip

sudo apt install redis-server php8.1-redis php8.1-amqp (php8.1-igbinary)
```

