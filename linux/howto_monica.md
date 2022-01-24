# Installation

```
sudo git clone https://github.com/monicahq/monica.git
sudo git checkout tags/v2.15.2
```

Base de données :
```sql
CREATE DATABASE monica DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON monica.* TO 'monica'@localhost IDENTIFIED BY 'pwdmoni';
FLUSH PRIVILEGES;
```

```
cd /var/www/monica
sudo cp .env.example .env
```

```conf
sudo vim .env
===============================================================================
APP_ENV=production
APP_URL=https://hnde.org/monica
DB_DATABASE=monica
DB_USERNAME=monica
DB_PASSWORD=xxxxxxxx
MAIL_DRIVER=smtp
MAIL_HOST=mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=d89b4f8aa53e26
MAIL_PASSWORD=b01d0f53682fca
MAIL_ENCRYPTION=tls
MAILER_FROM_ADDRESS="[TEST]"
MAILER_FROM_ADDRESS="Monica instance"
APP_DEFAULT_LOCALE=fr
===============================================================================
```

```
sudo composer install --no-interaction --no-suggest --no-dev
sudo php artisan key:generate
sudo php artisan setup:production -v
```

crontab -u www-data -e
```
* * * * * php /var/www/monica/artisan schedule:run
```

```
sudo chown -R www-data:www-data /var/www/monica
sudo chmod -R 775 /var/www/monica/storage
```

```conf
sudo nano /etc/apache2/sites-available/monica.conf
===============================================================================
<VirtualHost *:80>
    ServerName **YOUR IP ADDRESS/DOMAIN**

    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/monica/public

    <Directory /var/www/monica/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
===============================================================================
```

```
sudo a2dissite 000-default.conf
sudo a2ensite monica.conf
sudo service apache2 restart
```
