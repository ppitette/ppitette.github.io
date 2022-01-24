# Installation de Apache 2

```bash
sudo apt install apache2 apache2-doc apache2-utils

sudo a2enmod suexec rewrite ssl actions include cgi headers actions proxy_fcgi alias
=> a2enmod dav dav_fs auth_digest (pour utiliser WebDAV)

sudo service apache2 restart
```

[Test]
------
Depuis un navigateur => http://adresse_serveur/
Retour d'une page Apache2 Debian Default Page

## Vulnérabilité HTTPOXY

```bash
sudo nano /etc/apache2/conf-available/httpoxy.conf
```

Collez le contenu suivant dans le fichier :

```conf
<IfModule mod_headers.c>
    RequestHeader unset Proxy early
</IfModule>
```

Et activez le module en exécutant :

```bash
sudo a2enconf httpoxy
sudo service apache2 restart
```

## Vérification de la configuration apache
```
sudo apache2ctl configtest
```

## Sécurisation

```
vim /etc/apache2/apache2.conf
```

```
<Directory /var/www/>
    Options FollowSymLinks (suppression de 'Indexes')
</Directory>
```
(supprimer ou commenter éventuellement l'entrée <Directory /usr/share>)

## s'assurer de l'acces complet au répertoire et fichiers du site par apache2

```
sudo usermod -g www-data hnde
```

## Créer un lien symbolique vers le dossier contenant le site (/home/hnde/www/)

```
sudo ln -s /home/hnde/www /var/www/hnde
```

## Créer le VirtualHost correspondant

```
vim /etc/apache2/sites-available/001-hnde.conf
```

```
<VirtualHost *:80>
    ServerAdmin contact@hnde.org
    ServerName hnde.lan
    (ServerAliias www.hnde.lan)
    DocumentRoot /var/www/hnde
    
    <Directory /var/www/hnde>
        Options -Indexes +FollowSymLinks
        AllowOverride All
    </Directory>
    
    ErrorLog /home/hnde/logs/error.log
    CustomLog /home/hnde/logs/access.log combined
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
```

## Créer le fichier .htaccess (à la racine du site)

```
vim /home/hnde/www/.htaccess
```

```
RewriteEngine On
RewriteCond %{HTTP_HOST} ^www.hnde.lan$[NC]
ReWriteRule ^(.*)$ http://hnde.lan/$1 [R=301,L]
```
