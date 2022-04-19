# Installation de PHPMyAdmin

Depuis Debian 10, PHPMyAdmin n'est plus disponible sous forme de paquet `.deb`. C'est pourquoi nous l'installerons à partir des sources.

Créer des dossiers pour PHPMyadmin :

```
mkdir /usr/share/phpmyadmin
mkdir /etc/phpmyadmin
mkdir -p /var/lib/phpmyadmin/tmp
chown -R www-data:www-data /var/lib/phpmyadmin
touch /etc/phpmyadmin/htpasswd.setup
```

Allez dans le répertoire `/tmp` et téléchargez les sources de PHPMyAdmin :

```
cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.tar.gz
```

Décompressez le fichier d'archive téléchargé et déplacez les fichiers dans le dossier `/usr/share/phpmyadmin` et nettoyez le répertoire `/tmp`.

```
tar xfz phpMyAdmin-5.1.1-all-languages.tar.gz
mv phpMyAdmin-5.1.1-all-languages/* /usr/share/phpmyadmin/
rm phpMyAdmin-5.1.1-all-languages.tar.gz
rm -rf phpMyAdmin-5.1.1-all-languages
```

Créez un nouveau fichier de configuration pour PHPMyaAdmin à partir du fichier d'exemple fourni :

```
cp /usr/share/phpmyadmin/config.sample.inc.php  /usr/share/phpmyadmin/config.inc.php
(cp /usr/share/phpmyadmin_old/config.inc.php  /usr/share/phpmyadmin/config.inc.php)
```

Ouvrez le fichier de configuration avec votre éditeur :

```
nano /usr/share/phpmyadmin/config.inc.php
```

Définissez un mot de passe sécurisé (blowfish secret) qui doit faire 32 caractères :

```
$cfg['blowfish_secret'] = 'bD3e6wva9fnd93jVsb7SDgeiBCd452Dh'; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
```

N'utilisez pas mon blowfish secret d'exemple, mettez votre propre secret !

Ajoutez ensuite une ligne pour définir le répertoire que PHPMyAdmin doit utiliser pour stocker les fichiers temporaires :

```
$cfg['TempDir'] = '/var/lib/phpmyadmin/tmp';
```

Ensuite, nous créons le fichier de configuration Apache pour PHPMyAdmin en ouvrant un nouveau fichier avec `nano` :

```
nano /etc/apache2/conf-available/phpmyadmin.conf
```

Collez la configuration suivante dans le fichier et enregistrez-la.

```
# phpMyAdmin default Apache configuration

Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options FollowSymLinks
    DirectoryIndex index.php

    <IfModule mod_php7.c>
        AddType application/x-httpd-php .php
		php_flag magic_quotes_gpc Off
		php_flag track_vars On
		php_flag register_globals Off
		php_value include_path .
    </IfModule>

</Directory>

# Authorize for setup
<Directory /usr/share/phpmyadmin/setup>
	<IfModule mod_authn_file.c>
		AuthType Basic
		AuthName "phpMyAdmin Setup"
		AuthUserFile /etc/phpmyadmin/htpasswd.setup
	</IfModule>
	Require valid-user
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/libraries>
	Order Deny,Allow
	Deny from All
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
	Order Deny,Allow
	Deny from All
</Directory>
```

Activez la configuration et redémarrez Apache.

```
a2enconf phpmyadmin
systemctl restart apache2
```

Dans l'étape suivante, nous allons configurer le magasin de configuration de phpMyadmin (base de données).

Connectez-vous à MariaDB en tant qu'utilisateur root :

```
mysql -u root -p
```

Créez ensuite un nouvel utilisateur :

```
MariaDB [(none)]> CREATE USER 'pma'@'localhost' IDENTIFIED BY 'mypassword';
```

Remplacez le mot mypassword par un mot de passe sécurisé de votre choix dans les commandes ci-dessus et ci-dessous, utilisez le même mot de passe à chaque fois. Ensuite, accordez à l'utilisateur l'accès à cette base de données et rechargez les permissions de la base de données.

```
MariaDB [(none)]> CREATE DATABASE phpmyadmin;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'mypassword' WITH GRANT OPTION;
MariaDB [(none)]> FLUSH PRIVILEGES;
MariaDB [(none)]> EXIT;
```

Enfin, chargez les tables SQL dans la base de données :

```
mysql -u root -p phpmyadmin < /usr/share/phpmyadmin/sql/create_tables.sql
```

Entrez le mot de passe root MariaDB sur demande.

Il ne nous reste plus qu'à définir les détails de l'utilisateur phpmyadmin dans le fichier de configuration. Ouvrez à nouveau le fichier dans l'éditeur nano :

```
nano /usr/share/phpmyadmin/config.inc.php
```

Faites défiler vers le bas jusqu'à ce que vous voyez les lignes ci-dessous et éditez-les :

===============================================================================
/* User used to manipulate with storage */
$cfg['Servers'][$i]['controlhost'] = 'localhost';
$cfg['Servers'][$i]['controlport'] = '';
$cfg['Servers'][$i]['controluser'] = 'pma';
$cfg['Servers'][$i]['controlpass'] = 'mypassword';

/* Storage database and tables */
$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
$cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
$cfg['Servers'][$i]['relation'] = 'pma__relation';
$cfg['Servers'][$i]['table_info'] = 'pma__table_info';
$cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
$cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
$cfg['Servers'][$i]['column_info'] = 'pma__column_info';
$cfg['Servers'][$i]['history'] = 'pma__history';
$cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
$cfg['Servers'][$i]['tracking'] = 'pma__tracking';
$cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
$cfg['Servers'][$i]['recent'] = 'pma__recent';
$cfg['Servers'][$i]['favorite'] = 'pma__favorite';
$cfg['Servers'][$i]['users'] = 'pma__users';
$cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
$cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
$cfg['Servers'][$i]['savedsearches'] = 'pma__savedsearches';
$cfg['Servers'][$i]['central_columns'] = 'pma__central_columns';
$cfg['Servers'][$i]['designer_settings'] = 'pma__designer_settings';
$cfg['Servers'][$i]['export_templates'] = 'pma__export_templates';
===============================================================================

J'ai marqué en rouge les lignes que j'ai éditées. Remplacez mon mot de passe par le mot de passe que vous avez choisi pour l'utilisateur phpmyadmin. Notez que le // devant les lignes a également été supprimé !



$weeksession = 60*60*24*7;
ini_set('session.gc_maxlifetime', 604800);
$cfg['LoginCookieValidity'] = $weeksession;

