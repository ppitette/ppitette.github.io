# Installation Raspbian stretch

## Affichage correct de l'écran "officiel"

sudo nano /boot/config.txt
(ajouter la ligne suivante à la fin du fichier)
lcd_rotate=2

## Configuration en ligne de commande

sudo raspi-config
sudo rpi-update

## Suppression des packages inutilisés

sudo apt-get --purge remove wolfram-engine bluej greenfoot nodered nuscratch scratch sonic-pi libreoffice* claws-mail claws-mail-i18n minecraft-pi python-pygame
reboot
sudo apt-get autoremove --purge

## Suite de la configuration

sudo apt install zsh vim-nox mc vim-doc vim-scripts zsh-doc arj

wget http://formation-debian.via.ecp.fr/fichiers-config.tar.gz
tar xvzf fichiers-config.tar.gz
sudo cp vimrc /etc/vim/
sudo cp zshrc zshenv zlogin zlogout /etc/zsh/
sudo cp dir_colors /etc/

sudo vim /etc/adduser.conf
chsh <= /bin/zsh

## ssh en root

vim /etc/ssh/sshd_config

changer PermitRootLogin without-password
par     PermitRootLogin yes

ipfix maison : 78.235.15.131

apt-get remove -y --purge wolfram-engine coinor-libipopt1v5 libgmime-2.6-0 libgpgme11 libmumps-seq-4.10.0 libraw15

## Magic Mirror

/etc/xdg/lxsession/LXDE-pi/autostart

sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u pi --hp /home/pi

Discovering collections for pair Google_to_MagicMirror
Google:
  - "cpp2spjicln66q13d1nmoqb4c5sk0pridtqn0bjm5phm2r35dpi62shectnmuprcckn66rrd@virtual" ("Jours fériés en France")
  - "4dhmurjkc5hn8sq0ctp6utbg5pr2sor1dhimsp31e8n6errfctm6abj3dtmg@virtual" ("Contacts")
  - "family10810293532408473045@group.calendar.google.com" ("Famille")
  - "ppitette@gmail.com"

## LAMP

apt-get install git
apt-get install apache2
apt-get install php7.0 php7.0-xml php7.0-gd
apt-get install mariadb-server

root@www:~# vi /etc/mysql/mariadb.conf.d/50-server.cnf

```
# line 111,112: change like follows
character-set-server = utf8
# collation-server = utf8mb4_general_ci 
```

root@www:~# service mariadb restart

mysql_secure_installation 
(y) pour tout

install phpmyadmin php-mbstring php-gettext

Configure database for phpmyadmin with dbconfig-common? => Non

root@www:~# mysql -u root -p mysql
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 11
Server version: 10.1.23-MariaDB-9+deb9u1 Debian 9.0

Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [mysql]> update user set plugin='' where user='root'; 
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

MariaDB [mysql]> flush privileges; 
Qu	ery OK, 0 rows affected (0.00 sec)

MariaDB [mysql]> exit
