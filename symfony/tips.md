# Symfony Cheat sheet et Mise en place du projet APHF Symfony4

## Prérequis système
Sur un environnement windows10 :
* wamp64
* git
* nodejs
* yarn

## Création du projet

```
composer create-project symfony/website-skeleton project
composer create-project symfony/symfony-demo
```

## Initialisation du dépôt git
Si git n'est pas déjà configuré sur la machine :

```
git config --global user.email "ppitette@gmail.com"
git config --global user.name "Pascal Pitette"
```

puis

```
git init
git add .
git commit -m "Initial commit"
```

local => GitHub

```
git push origin master
```

local <= GitHub

```
git pull origin master
```

## Entités

```
php bin/console make:entity
php bin/console make:entity --regenerate --overwrite
```

## Doctrine

```
php bin/console make:migration
php bin/console doctrine:migrations:migrate
php bin/console doctrine:query:sql 'SELECT * FROM xxxx'
```

## Encore

```
usage encore [dev|prod|production|dev-server]

encore is a thin executable around the webpack or webpack-dev-server executables

Commands:
    dev        : runs webpack for development
       - Supports any webpack options (e.g. --watch)

    dev-server : runs webpack-dev-server
       - --host The hostname/ip address the webpack-dev-server will bind to
       - --port The port the webpack-dev-server will bind to
       - --hot  Enable HMR on webpack-dev-server
       - --keep-public-path Do not change the public path (it is usually prefixed by the dev server URL)
       - Supports any webpack-dev-server options

    production : runs webpack for production
       - Supports any webpack options (e.g. --watch)

    encore dev --watch
    encore dev-server
    encore production
```

## Regex

```
var code_postal = /^(([0-8][0-9])|(9[0-5]))[0-9]{3}$/;
var code_insee = "^(([0-8][0-9])|(9[0-5])|(2[ab]))[0-9]{3}$";
```

## Repository

### Récupérer une entité du jour X

```
public function getByDate(\Datetime $date)
{
    $from = new \DateTime($date->format("Y-m-d")." 00:00:00");
    $to   = new \DateTime($date->format("Y-m-d")." 23:59:59");

    $qb = $this->createQueryBuilder("e");
    $qb
        ->andWhere('e.date BETWEEN :from AND :to')
        ->setParameter('from', $from )
        ->setParameter('to', $to)
    ;
    $result = $qb->getQuery()->getResult();

    return $result;
}
```
