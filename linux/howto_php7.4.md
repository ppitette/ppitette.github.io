# Installation de PHP 7.4

## Ajouter le dépot SURY PHP PPA
```
sudo apt -y install lsb-release apt-transport-https ca-certificates
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update
```

## Installation de PHP (apache)
```
sudo apt install php7.4 (php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline libapache2-mod-php7.4)
sudo apt install php7.4-mysql php7.4-sqlite3
sudo apt install php7.4-intl php7.4-mbstring php7.4-xml
sudo apt install php7.4-curl php7.4-gd php7.4-zip php7.4-redis php7.4-curl php7.4-pgsql
sudo apt install php7.4-imagick

(php7.4-bcmath php7.4-cgi php7.4-gmp php7.4-imap)

sudo apt install php7.4 php7.4-bcmath php7.4-cgi php7.4-cli php7.4-curl php7.4-gd php7.4-gmp php-imagick php7.4-imap php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-sqlite3 php7.4-xml php7.4-zip libapache2-mod-php7.4
```

## Installation de PHP (nginx)
```
sudo apt install php7.4 php7.4-bcmath php7.4-cgi php7.4-cli php7.4-curl php7.4-gd php7.4-gmp php-imagick php7.4-imap php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-sqlite3 php7.4-xml php7.4-zip php7.4-fpm
```

## Test

```
sudo nano /var/www/html/info.php
==========================================================================
<?php
    phpinfo();
?>
==========================================================================
```
Depuis un navigateur => http://adresse_serveur/info.php
Retour d'une page d'informations sur l'installation de PHP
