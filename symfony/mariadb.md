# MariaDB sheat cheet

## acces
sudo mysql -u root -p
mot de passe

## selection d'une bas de données
USE database;

## suppresion d'une base de donnée
DROP DATABASE database;

## vidage d'une base de donnée
FLUSH DATABASE database;

## Sauvegarde d'une base de données (hors mysql)
mysqldump -u root -p datav=base > sauvegarde.sql

## Restauration d'une base de données (hors mysql)
mysql -u root -pxxxxxx database < sauvegarde.sql
