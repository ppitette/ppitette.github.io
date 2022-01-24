# docker et docker-compose

## docker

docker exec -it symfony_db bash

## docker-compose

docker-compose up -d            ! pour démarrer l'ensemble des conteneurs en arrière-plan
docker-compose ps               ! pour voir le status de l'ensemble de votre stack
docker-compose logs -f --tail 5 ! pour afficher les logs de votre stack
docker-compose stop             ! pour arrêter l'ensemble des services d'une stack
docker-compose down             ! pour détruire l'ensemble des ressources d'une stack
docker-compose config           ! pour valider la syntaxe de votre fichier docker-compose.yml

## debug sur le rseau :

sudo netstat -pna | grep 80

## commandes

docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)
