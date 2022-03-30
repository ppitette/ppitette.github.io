# Gestion des conteneurs Docker avec Traefik v2 et Portainer

[Article original](https://rafrasenberg.com/posts/docker-container-management-with-traefik-v2-and-portainer/)

## Introduction

Conditions préalables

- Serveur Ubuntu 20.04
- docker & docker-compose installés
- Nom de domaine

### Qu'est-ce que nous créons ?

Dans cet article, nous allons plonger dans le monde des conteneurs. Nous allons configurer un reverse proxy Traefik v2 avec Portainer, en utilisant Docker Compose.

Cette configuration fait de la gestion et du déploiement des conteneurs un jeu d'enfant et le reverse proxy permet d'exécuter plusieurs applications sur un hôte Docker. Cela réduit vraiment les frais généraux qui accompagnent normalement l'exécution de plusieurs applications Docker, puisque tout est géré à partir d'un seul point.

Traefik acheminera tout le trafic entrant vers les conteneurs docker appropriés et, grâce à l'application open-source Portainer, vous pourrez accélérer les déploiements de logiciels, résoudre les problèmes et simplifier les migrations.

Comme dernier exemple, nous allons déployer une application Node.js conteneurisée dans notre nouvel environnement.

## Qu'est-ce que Traefik v2 ?

Traefik est un reverse proxy et un équilibreur de charge moderne et léger qui facilite le déploiement de microservices. Il est conçu pour être aussi simple que possible à utiliser, mais capable de gérer des déploiements importants et très complexes.

Il est également livré avec un ensemble puissant de logiciels intermédiaires qui améliorent ses capacités, notamment l'équilibrage de charge, la passerelle API, l'orchestrateur ingress, ainsi que la communication de services est-ouest et plus encore. Il est écrit en Go et est emballé sous la forme d'un seul fichier binaire et disponible sous la forme d'une minuscule image docker officielle.

Les reverse-proxies traditionnels exigent que vous configuriez chaque route qui connectera les chemins et les sous-domaines à chaque microservice. Dans un environnement où vous ajoutez, supprimez, tuez, mettez à niveau ou mettez à l'échelle vos services plusieurs fois par jour, la tâche de maintenir les routes à jour devient fastidieuse.

Traefik écoute l'API de votre registre de services/orchestrateur et génère instantanément les routes afin que vos microservices soient connectés au monde extérieur - sans autre intervention de votre part.

![image_1](docker_traefik_portainer_1.png)

Certaines des caractéristiques de Traefik sont expliquées plus en détail :

Routage dynamique : Une fois correctement configuré, Traefik ajoutera dynamiquement de nouveaux services et conteneurs au fur et à mesure qu'ils apparaissent pour leur fournir un routage du trafic. Disons que vous avez Traefik en cours d'exécution et que vous voulez ajouter une nouvelle application, il suffit de construire votre conteneur et d'enregistrer un nouveau point de terminaison et Traefik le détectera automatiquement et commencera à acheminer le trafic vers lui.

Équilibreur de charge : Si vous avez plusieurs instances d'un conteneur, Traefik peut fournir un équilibrage de charge entre ces instances.

Letsencrypt : Lorsqu'il est correctement configuré, Traefik peut non seulement acheminer le trafic vers un service nouvellement découvert, mais aussi mettre en place des certs SSL gratuits de Let's Encrypt. Ensuite, il peut rediriger tout le trafic http vers https par le biais de middlewares pour renforcer la sécurité de votre application.

Interface utilisateur Web : Il est livré avec un tableau de bord de gestion très utile qui vous aide à visualiser tous les points de terminaison du trafic, les services, les middlewares et les conteneurs docker, tout en affichant les avertissements et les erreurs potentiels.

![image_2](docker_traefik_portainer_2.png)

## Qu'est-ce que le Portainer ?

Portainer est une interface de gestion légère qui vous permet de gérer facilement votre hôte Docker ou votre cluster Swarm.

Il se veut aussi simple à déployer qu'à utiliser. Il se compose d'un seul conteneur qui peut fonctionner sur n'importe quel moteur Docker. Il vous permet de gérer vos piles Docker, vos conteneurs, vos images, vos volumes, vos réseaux et bien plus encore ! Vous pourrez ainsi accélérer les déploiements de logiciels, résoudre les problèmes et simplifier les migrations.

Portainer fonctionne en cachant la complexité qui rend la gestion des conteneurs difficile derrière une interface graphique facile à utiliser. En annulant la nécessité pour les utilisateurs d'utiliser les CLI, d'écrire YAML ou de comprendre les fichiers manifests, Portainer rend le déploiement d'applications et le dépannage des problèmes si simples que tout le monde peut le faire.

![image_3](docker_traefik_portainer_3.png)

## Construction de notre Stack.

À partir de ce point, je vais supposer que vous avez docker et docker-compose installés sur votre serveur et que vous utilisez Ubuntu 20.04.

### I. Configuration des enregistrements DNS

La première chose à faire est de configurer les domaines appropriés pour que nous puissions accéder à nos tableau de bord Portainer et Traefik. Configurez-les comme ceci, pointez vers votre serveur :

```
traefik.votredomaine.com
portainer.votredomaine.com
```

De cette façon, nos tableau de bord Portainer & Traefik seront disponibles sur les sous-domaines appropriés.

### II. Créer un utilisateur et configurer le répertoire

En général, vous voulez éviter d'utiliser votre serveur en tant que root, donc enregistrez un utilisateur et ajoutez-le au groupe sudo, puis passez à cet utilisateur :

```
$ adduser raf
$ usermod -aG sudo raf
$ su - raf
```

Maintenant il est temps de mettre en place notre répertoire. J'ai déjà fait toute la configuration et l'ai publiée et vous pouvez donc simplement cloner ou forker mon repo. Je vais passer en revue tous les fichiers pour expliquer ce qui se passe. Donc lancez simplement :

```
$ git clone https://github.com/rafrasenberg/docker-traefik-portainer ./src
```

Maintenant cd dans src et vous devriez être accueilli avec cette structure arborescente :

```
.
└── src/
    ├── core/
    │   ├── traefik-data/
    │   │   ├── configurations/
    │   │   │   └── dynamic.yml
    │   │   ├── traefik.yml
    │   │   └── acme.json
    │   └── docker-compose.yml
    └── apps/
```

## Explication du fichier

### I. traefik.yml

Le premier fichier que nous allons examiner est le fichier `traefik.yml`, comme le montre l'extrait de code ci-dessous. Il s'agit de la configuration statique de base de Traefik.

Tout d'abord, nous indiquons à Traefik que nous voulons l'interface graphique Web en définissant `dashboard:true`.

Après cela, nous définissons nos deux points d'entrée `web` (http) et `websecure` (https). Pour notre point d'entrée sécurisé `https`, nous configurons le `certResolver` afin que nous puissions profiter des certificats automatiques de Let's Encrypt ! Ensuite, nous chargeons le middleware approprié pour que tout notre trafic soit transféré vers https.

Dans la partie `providers`, nous spécifions que ce fichier sera transmis à un conteneur docker en utilisant bind mount. Nous indiquons également à Traefik de trouver notre configuration dynamique dans `configurations/dynamic.yml`. Et enfin, la configuration pour notre résolveur de certificat SSL.

```yml
# traefik.yml
api:
  dashboard: true

entryPoints:
  web:
    address: :80
    http:
      redirections:
        entryPoint:
          to: websecure

  websecure:
    address: :443
    http:
      middlewares:
        - secureHeaders@file
      tls:
        certResolver: letsencrypt

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
  file:
    filename: /configurations/dynamic.yml

certificatesResolvers:
  letsencrypt:
    acme:
      email: raf@yourdomain.com
      storage: acme.json
      keyType: EC384
      httpChallenge:
        entryPoint: web
```

> Note : Assurez-vous de configurer un email dans ce fichier pour le renouvellement de Let's Encrypt. @votredomaine.com risque de provoquer une erreur lorsque vous voudrez exécuter votre conteneur docker !

### II. dynamic.yml

Ce fichier contient nos middlewares pour s'assurer que tout notre trafic est entièrement sécurisé et fonctionne sur TLS. Nous définissons également ici l'authentification de base pour notre tableau de bord Traefik, car par défaut il est accessible à tous.

Le fichier est entièrement dynamique et peut être modifié à la volée, sans redémarrer notre conteneur.

```yml
# dynamic.yml
http:
  middlewares:
    secureHeaders:
      headers:
        sslRedirect: true
        forceSTSHeader: true
        stsIncludeSubdomains: true
        stsPreload: true
        stsSeconds: 31536000

    user-auth:
      basicAuth:
        users:
          - "raf:$apr1$MTqfVwiE$FKkzT5ERGFqwH9f3uipxA1"

tls:
  options:
    default:
      cipherSuites:
        - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305
        - TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305
      minVersion: VersionTLS12
```

### III. docker-compose.yml

Le fichier le plus important. C'est ici que les bonnes choses arrivent. La beauté de Traefik est qu'une fois que vous avez fait la configuration initiale, le déploiement de nouveaux conteneurs est très facile. Cela fonctionne en spécifiant des `labels` pour vos conteneurs.

```yml
# docker-compose.yml
version: "3"

services:
  traefik:
    image: traefik:latest
    container_name: traefik
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    networks:
      - proxy
    ports:
      - 80:80
      - 443:443
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./traefik-data/traefik.yml:/traefik.yml:ro
      - ./traefik-data/acme.json:/acme.json
      - ./traefik-data/configurations:/configurations
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=proxy"
      - "traefik.http.routers.traefik-secure.entrypoints=websecure"
      - "traefik.http.routers.traefik-secure.rule=Host(`traefik.yourdomain.com`)"
      - "traefik.http.routers.traefik-secure.service=api@internal"
      - "traefik.http.routers.traefik-secure.middlewares=user-auth@file"

  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    networks:
      - proxy
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./portainer-data:/data
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=proxy"
      - "traefik.http.routers.portainer-secure.entrypoints=websecure"
      - "traefik.http.routers.portainer-secure.rule=Host(`portainer.yourdomain.com`)"
      - "traefik.http.routers.portainer-secure.service=portainer"
      - "traefik.http.services.portainer.loadbalancer.server.port=9000"

networks:
  proxy:
    external: true
```

Pour chaque conteneur que vous voulez que Traefik gère, vous ajoutez des étiquettes afin que Traefik sache où il doit le diriger. Ainsi, lorsque nous regardons le fichier ci-dessus, vérifions rapidement ce qui se passe au niveau du conteneur `traefik`.

Nous attachons donc le première `label`, qui indique à Traefik qu'il doit router ce conteneur parce que nous spécifions `enable=true`. C'est le résultat de la configuration dans le fichier statique `traefik.yml` où nous avons explicitement indiqué `exposedByDefault : false` et donc nous devons le spécifier.

Le second label nous indique que nous devons utiliser le réseau `proxy`, que nous allons créer plus tard. Après cela, nous disons à Traefik d'utiliser notre endpoint `websecure` (https). Nous spécifions ensuite notre nom d'hôte avec le domaine approprié.

L'avant-dernière étiquette spécifie le gestionnaire d'API. Il expose des informations telles que la configuration de tous les routeurs, services, middlewares, etc. Pour voir tous les endpoints disponibles, vous pouvez consulter les docs.

La toute dernière étiquette est notre middleware d'authentification de base, vous vous souvenez ? Parce que le tableau de bord Traefik est exposé par défaut, nous ajoutons une couche de sécurité de base sur celui-ci. Cela protégera également notre API.

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.docker.network=proxy"
  - "traefik.http.routers.traefik-secure.entrypoints=websecure"
  - "traefik.http.routers.traefik-secure.rule=Host(`traefik.yourdomain.com`)"
  - "traefik.http.routers.traefik-secure.service=api@internal"
  - "traefik.http.routers.traefik-secure.middlewares=user-auth@file"
```

## Exécution de notre Stack.

### I. Création des informations d'identification

La première chose à faire est donc de générer le mot de passe pour l'authentification de base qui sera stocké dans le fichier `dynamic.yml`. Ces informations d'identification seront nécessaires lors de la tentative de connexion à notre interface Web Traefik et elles protégeront l'API.

Assurez-vous que `htpasswd` est installé sur votre serveur. Si ce n'est pas le cas, vous pouvez le faire avec la commande suivante :

```
$ sudo apt install apache2-utils
```

Exécutez ensuite la commande suivante, en remplaçant le nom d'utilisateur et le mot de passe par ceux que vous souhaitez utiliser.

```
$ echo $(htpasswd -nb <username> <password>)
```

Editez le fichier `dynamic.yml` et ajoutez votre chaîne d'authentification sous le middleware `user-auth` comme vu dans l'exemple de code.

### II. Création du réseau `proxy`

Nous devons créer un nouveau réseau Docker qui autorisera le trafic extérieur. Celui-ci doit être appelé proxy comme nous l'avons spécifié dans notre fichier docker-compose.yml :

```yaml
networks :
  - proxy
```

Pour créer un réseau Docker, utilisez :

```
$ docker network create proxy
```

### III. Modification des noms de domaine

Ouvrez le fichier `docker-compose.yml` et assurez-vous de remplacer les valeurs de domaine dans les étiquettes Traefik par les domaines que vous envoyez au serveur comme fait précédemment :

```
traefik.votredomaine.com
portainer.votredomaine.com
```

### IV. Donner les permissions appropriées à `acme.json`.

Par défaut, la permission du fichier `acme.json` est fixée à `644`, ce qui entraînera une erreur lors de l'exécution de `docker-compose`. Assurez-vous donc de définir les permissions de ce fichier particulier à `600`. Allez dans le dossier `core` et exécutez la commande suivante :

```
$ sudo chmod 600 ./traefik-config/acme.json
```

### V. Exécution de la pile

Il est maintenant temps d'exécuter la pile. Assurez-vous que vous êtes dans le dossier `core` pour que docker puisse trouver le fichier `docker-compose`. Lors de la première exécution, j'aime toujours vérifier l'absence d'erreurs dans le processus avant d'utiliser le drapeau docker-compose `--detach`. Exécutez la commande suivante :

```
$ sudo docker-compose up
```

Dès maintenant, le tableau de bord de Traefik devrait être disponible sur `traefik.yourdomain.com` et `portainer.yourdomain.com`, génial !

Lorsque vous êtes sûr que vos conteneurs fonctionnent correctement, exécutez-les en arrière-plan en utilisant l'option `--detach` :

```
$ sudo docker-compose down && sudo docker-compose up -d
```

## Ajouter des applications docker à notre serveur

Très bien, notre environnement est donc configuré, laissez-moi vous montrer maintenant comment il est facile de déployer des conteneurs sur notre nouvelle configuration Traefik.

C'est ici que la magie opère. Il m'a fallu 2 minutes au total pour trouver une application dockerisée sur internet, la déployer et la rendre disponible sur le web. Pouvez-vous croire cela ? DEUX MINUTES ! Si tous mes déploiements étaient aussi faciles...

Quoi qu'il en soit, voici les étapes que j'ai suivies.

J'ai fait pointer le domaine que je veux utiliser pour l'application, vers le serveur. Pour cet exemple, j'ai utilisé `express.domain.com`.

Après cela, j'ai cherché sur Google "docker express starter" et j'ai trouvé un repo et j'ai forké. Ensuite, sur le serveur, je suis allé dans le dossier `apps` et j'ai lancé `git clone`

```
$ git clone https://github.com/rafrasenberg/docker-express-postgres ./express
```

Après cela, il était temps d'éditer le fichier `docker-compose.yml` de notre application :

```yaml
# docker-compose.yml (from the internet repo)
version: "3"
services:
  app:
    build: .
    depends_on:
      - postgres
    environment:
      DATABASE_URL: postgres://user:pass@postgres:5432/db
      NODE_ENV: development
      PORT: 3000
    ports:
      - "3000:3000"
    command: npm run dev
    volumes:
      - .:/app/
      - /app/node_modules

  postgres:
    image: postgres:10.4
    ports:
      - "35432:5432"
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: db
```

Maintenant vous pouvez vous demander, comment dois-je aborder cela ? La première chose que nous faisons est de supprimer la section des `ports`, puisque Traefik s'en occupe. Pour l'ensemble de la configuration de Traefik, nous devons seulement ajouter 4 étiquettes :

```
labels:
  - "traefik.enable=true"
  - "traefik.docker.network=proxy"
  - "traefik.http.routers.app-secure.entrypoints=websecure"
  - "traefik.http.routers.app-secure.rule=Host(`express.yourdomain.com`)"
```

Que se passe-t-il ici ?

Tout d'abord, nous activons ce conteneur avec `enable=true`, puis nous l'ajoutons au réseau `proxy`. Après cela, nous spécifions les routeurs et les points d'entrée.

> Notez que cette partie : `traefik.http.router.app-secure` doit avoir une identification unique du routeur. Donc assurez-vous que vous n'avez pas encore utilisé ce nom. Disons que vous voulez déployer exactement la même application sur un domaine et une instance de conteneur différents, vous pouvez utiliser ce label : `traefik.http.router.app1-secure`. Assurez-vous simplement qu'il s'agit d'une valeur unique.

Maintenant la dernière partie que nous devons faire dans le fichier `docker-compose.yml` est de spécifier les réseaux. Donc le fichier final `docker-compose.yml` ressemblera à ceci :

```
# docker-compose.yml
version: "3"
services:
  app:
    build: .
    depends_on:
      - postgres
    environment:
      DATABASE_URL: postgres://user:pass@postgres:5432/db
      NODE_ENV: development
      PORT: 3000
    command: npm run dev
    volumes:
      - .:/app/
      - /app/node_modules
    networks:
      - proxy
      - default
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=proxy"
      - "traefik.http.routers.app-secure.entrypoints=websecure"
      - "traefik.http.routers.app-secure.rule=Host(`express.rasenberg.tech`)"
  postgres:
    image: postgres:10.4
    ports:
      - "35432:5432"
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: db

networks:
  proxy:
    external: true
```

Maintenant, nous allons lancer notre conteneur :
```
$ sudo docker-compose up -d
```

C'est tout ! Nous avons littéralement ajouté moins de 10 lignes à notre fichier `docker-compose.yml` et notre conteneur est déployé et prêt à recevoir du trafic. Génial n'est-ce pas !

Maintenant, notre nouvelle application apparaît également dans Portainer :

![image_4](docker_traefik_portainer_4.png)

Maintenant, chaque fois que vous voulez ajouter une nouvelle application sur votre serveur, il suffit de répéter les dernières étapes. C'est aussi simple que cela !

## Conclusion

Récapitulons.

Nous avons mis en place une pile de configuration impressionnante pour exécuter et gérer plusieurs conteneurs docker sur un serveur. Le déploiement de nouveaux projets sera très facile après cette configuration initiale.

Dans le prochain article, j'aimerais aborder l'intégration d'un pipeline CI de base qui se connecte à notre droplet afin que nous puissions automatiquement mettre à jour nos conteneurs lors d'une poussée de code vers Github. Restez donc à l'écoute pour cela !

A la prochaine fois !

