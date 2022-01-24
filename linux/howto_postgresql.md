# Postgresql

## Installation
```
sudo apt install postgresql postgresql-client php7.4-pgsql
sudo service postgresql status
```

## Création du mot de passe

```
sudo passwd postgres
```

Entrez le nouveau mot de passe UNIX : xxxxx
Retapez le nouveau mot de passe UNIX : xxxxx
passwd : le mot de passe a été mis à jour avec succès

## Accès à Postgresql

```
su postgres
```

Mot de passe : xxxxx

```
createuser hnde
```

## Par défaut le nouvel utilisateur n’a pas de mot de passe, il faut donc le créer

```
psql -d template1 -c "alter user hnde with password 'uVqH&9bMY8UjntU'"
```

=> Il y a donc un utilisateur hnde avec un mot de passe uVqH&9bMY8UjntU

## Création d’une base de données
La commande suivante, permet de créer la base de données hnde pour l’utilisateur hnde en utilisant l’encodage UNICODE :

```
createdb -O hnde -E UNICODE hnde
```

## On teste

```
psql -l -U hnde -h localhost
```
