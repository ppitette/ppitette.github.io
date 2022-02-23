# Serveur MariaDB

## Installation

```
sudo apt install software-properties-common dirmngr
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirror.biznetgio.com/mariadb/repo/10.6/debian buster main'
sudo apt update
sudo apt install mariadb-server mariadb-client
```

## Pour rendre MariaDB accessible depuis toutes les interfaces

```
sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
(commenter la ligne bind-address)
==========================================================================
# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
#bind-address           = 127.2.0.1
==========================================================================
```

## Sécuriser MariaDB

```
sudo mysql_secure_installation
==========================================================================
Enter current password for root (enter for none):

Set root password? [Y/n] N
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables..
 ... Success!

Remove anonymous users? [Y/n] y
Disallow root login remotely? [Y/n] y
Remove test database and access to it? [Y/n] y
Reload privilege tables now? [Y/n] y

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.
==========================================================================
```

## Authentification par mot de passe

Pour PHPMyadmin ou Adminer

```bash
(conseil => à faire en 'vrai' root : su -)
echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root
```

```bash
nano /etc/mysql/debian.cnf
===============================================================================
# Automatically generated for Debian scripts. DO NOT TOUCH!
[client]
host = localhost
user = root
password = howtoforge
socket = /var/run/mysqld/mysqld.sock
[mysql_upgrade]
host = localhost
user = root
password = howtoforge
socket = /var/run/mysqld/mysqld.sock
basedir = /usr
===============================================================================
```
