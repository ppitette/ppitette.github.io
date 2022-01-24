# Comment créer des certificats Let's Encrypt Wildcard avec Certbot

source : [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-create-let-s-encrypt-wildcard-certificates-with-certbot)

## Introduction

Un certificat wildcard est un certificat SSL qui permet de sécuriser un nombre quelconque de sous-domaines avec un seul certificat. Vous pouvez avoir besoin d'un certificat wildcard dans les cas où vous devez prendre en charge plusieurs sous-domaines mais ne souhaitez pas les configurer tous individuellement.

Let's Encrypt est une autorité de certification SSL qui accorde des certificats gratuits à l'aide d'une API automatisée. Dans ce tutoriel, vous allez créer un certificat sauvage Let's Encrypt en suivant les étapes suivantes :

* S'assurer que votre DNS est correctement configuré.
* Installer les plugins Certbot nécessaires pour réaliser des défis basés sur le DNS.
* Autoriser Certbot à accéder à votre fournisseur DNS
* Récupérer vos certificats

Ces informations sont censées être utiles pour n'importe quelle distribution Linux et n'importe quel logiciel serveur, mais vous devrez peut-être combler certaines lacunes en consultant d'autres documents, que nous mettrons en lien au fur et à mesure.

## Conditions préalables

Ce tutoriel suppose que vous avez déjà les éléments suivants :

- L'utilitaire Certbot installé, version `0.22.0` ou ultérieure. Si vous avez besoin d'aide pour installer Certbot, veuillez visiter notre page de tags [Let's Encrypt](https://www.digitalocean.com/community/tags/let-s-encrypt), où vous trouverez des guides d'installation pour une variété de distributions Linux et de serveurs. Certaines configurations courantes sont listées ci-dessous :
  - [Comment sécuriser Nginx avec Let's Encrypt sur Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04)
  - [Comment sécuriser Apache avec Let's Encrypt sur Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-20-04)
  - [Comment utiliser le mode autonome de Certbot pour récupérer les certificats SSL Let's Encrypt sur Ubuntu 18.04] (https://www.digitalocean.com/community/tutorials/how-to-use-certbot-standalone-mode-to-retrieve-let-s-encrypt-ssl-certificates-on-ubuntu-1804)
- Un nom de domaine, et un fournisseur DNS qui est supporté par Certbot. Voir la liste des plugins DNS de Certbot pour la liste des fournisseurs supportés.

Commençons par configurer et tester nos enregistrements DNS.

## Étape 1 - Configuration du Wildcard DNS

Avant d'aller chercher notre certificat SSL wildcard, nous devons nous assurer que notre serveur répond aux demandes de plusieurs sous-domaines. Pour ce faire, il suffit généralement de configurer un enregistrement DNS joker, qui ressemble à ceci :

```
*.exemple.com.   3600 IN A 203.0.113.1
```

Le caractère générique * est traité comme un stand-in pour tout nom d'hôte. Cet exemple d'enregistrement DNS correspondrait à `one.example.com` et `two.example.com`. Il ne correspondrait pas au simple `example.com` ni à `one.two.example.com`, car le caractère générique * ne s'étend qu'à un seul nom d'hôte, et non à plusieurs niveaux de noms.

De plus, un enregistrement DNS avec un caractère de remplacement ne peut avoir qu'un seul caractère de remplacement, donc *.*.exemple.com n'est pas autorisé.

Veuillez vous référer à la documentation de votre fournisseur DNS pour configurer les entrées DNS correctes. Vous voudrez ajouter un enregistrement joker A ou CNAME avant de continuer.

Remarque : Si vous utilisez DigitalOcean pour gérer vos DNS, veuillez consulter la section Comment créer, modifier et supprimer des enregistrements DNS dans la documentation de notre produit pour plus d'informations.

Pour tester que votre DNS wildcard fonctionne comme prévu, utilisez la commande host pour interroger quelques noms d'hôtes :

```
host one.example.com
```
 
Veillez à substituer votre propre domaine et nom d'hôte ci-dessus. N'oubliez pas non plus qu'il faut parfois quelques minutes pour que les enregistrements DNS se propagent dans le système. Si vous venez d'ajouter votre enregistrement DNS et que vous obtenez des erreurs, attendez quelques minutes et réessayez.

Lorsque le nom d'hôte que vous avez entré se résout correctement, vous obtiendrez un résultat similaire au suivant :

```
one.example.com has address 203.0.113.1
```

Sinon, vous verrez une erreur NXDOMAIN :

```
Host one.example.com not found: 3(NXDOMAIN)
```

Une fois que vous avez vérifié que plusieurs sous-domaines se résolvent sur votre serveur, vous pouvez passer à l'étape suivante, où vous allez configurer Certbot pour qu'il se connecte à votre fournisseur DNS.

## Étape 2 - Installation du bon plugin Certbot DNS

Avant d'émettre des certificats, Let's Encrypt effectue un challenge pour vérifier que vous contrôlez les hôtes pour lesquels vous demandez des certificats. Dans le cas d'un certificat wildcard, nous devons prouver que nous contrôlons l'ensemble du domaine. Pour ce faire, nous répondons à un défi basé sur le DNS, où Certbot répond au défi en créant un enregistrement DNS spécial dans le domaine cible. Les serveurs de Let's Encrypt vérifient ensuite cet enregistrement avant de délivrer le certificat.

Afin de se connecter à votre fournisseur DNS, Certbot a besoin d'un plugin. Veuillez consulter la [liste des plugins DNS de Certbot](https://certbot.eff.org/docs/using.html#dns-plugins) pour obtenir le nom du plugin approprié pour votre fournisseur DNS.

Par exemple, le fournisseur DigitalOcean s'appelle `certbot-dns-digitalocean`. Nous pouvons installer le plugin `certbot-dns-digitalocean` sur Ubuntu et Debian en installant le paquet suivant :

```
sudo apt install python3-certbot-dns-digitalocean
```

Les autres plugins doivent suivre le même format de dénomination. Remplacez le nom de votre fournisseur dans la commande ci-dessus si vous utilisez un service différent.

Il se peut également que vous deviez installer des dépôts de paquets supplémentaires sur ces distributions pour avoir accès aux paquets du plugin Certbot.

Pour vérifier que le plugin a été installé correctement, vous pouvez demander à Certbot de lister ses plugins actuels :

```
certbot plugins
```

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
* dns-digitalocean
Description: Obtain certs using a DNS TXT record (if you are using DigitalOcean
for DNS).
Interfaces: IAuthenticator, IPlugin
Entry point: dns-digitalocean =
certbot_dns_digitalocean.dns_digitalocean:Authenticator

* standalone
Description: Spin up a temporary webserver
Interfaces: IAuthenticator, IPlugin
Entry point: standalone = certbot.plugins.standalone:Authenticator

* webroot
Description: Place files in webroot directory
Interfaces: IAuthenticator, IPlugin
Entry point: webroot = certbot.plugins.webroot:Authenticator
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

Dans la sortie ci-dessus, le plugin `dns-digitalocean` est listé en premier, ainsi que les plugins `standalone` et `webroot` par défaut.

Lorsque vous avez vérifié que le bon plugin est installé, passez à l'étape suivante pour le configurer.

## Étape 3 - Configuration du plugin Certbot

Certbot devant se connecter à votre fournisseur DNS et créer des enregistrements DNS en votre nom, vous devez l'autoriser à le faire. Cela implique d'obtenir un jeton API ou d'autres informations d'authentification de la part de votre fournisseur DNS, et de les placer dans un fichier d'informations d'identification sécurisé que Certbot pourra lire ultérieurement.

Comme chaque fournisseur a un processus d'authentification différent, veuillez vous référer à la documentation de votre [plugin DNS Certbot](https://certbot.eff.org/docs/using.html#dns-plugins) particulier pour plus d'informations sur les jetons ou les clés que vous devrez obtenir.

Pour cet exemple, nous continuerons à utiliser le plugin `dns-digitalocean`, et nous stockerons nos informations d'identification dans le fichier `~/certbot-creds.ini`.

Nous allons créer ce fichier en utilisant l'éditeur de texte `nano` :

```
nano ~/certbot-creds.ini
```

Cela ouvrira un nouveau fichier texte vierge. Vous voudrez ajouter vos informations en fonction des instructions de votre fournisseur DNS particulier. DigitalOcean exige un seul jeton API, donc il ressemblera à ceci :

```
dns_digitalocean_token = 235dea9d8856f5b0df87af5edc7b4491a92745ef617073f3ed8820b5a10c80d2
```

Veillez à remplacer l'exemple de jeton ci-dessus par vos propres informations.

Sauvegardez et fermez le fichier. Si vous utilisez `nano`, tapez `CTRL+O` (pour "write out"), appuyez sur `ENTER`, puis `CTRL+X` pour quitter.

Après avoir créé le fichier, vous devrez restreindre ses permissions afin que votre secret ne soit pas divulgué aux autres utilisateurs. La commande chmod suivante donnera l'accès en lecture et en écriture à votre seul utilisateur :

```
chmod 600 ~/certbot-creds.ini
```

Une fois que vous avez configuré votre fichier d'informations d'identification, vous êtes prêt à demander le certificat.

## Étape 4 - Récupération du certificat

A ce stade, la récupération de votre certificat Let's Encrypt wildcard est similaire à celle des certificats "normaux" non wildcard. Les principaux changements au processus sont de spécifier le défi basé sur le DNS, et de pointer vers notre fichier d'informations d'identification DNS. De plus, nous utiliserons un domaine joker avec le drapeau `-d` :

```
sudo certbot certonly --dns-digitalocean --dns-digitalocean-credentials ~/certbot-creds.ini -d '*.example.com'
```

Notez que vous ne pouvez pas utiliser les plugins `--nginx` ou `--apache` pour configurer automatiquement ces serveurs avec un certificat joker. Nous utilisons la commande `certonly` à la place, pour télécharger uniquement le certificat.

Lors de l'exécution de la commande ci-dessus, quelques questions vous seront posées si c'est la première fois que vous utilisez Certbot. Après avoir répondu à ces questions, Cerbot effectuera le défi, les serveurs de Let's Encrypt le vérifieront, et votre nouveau certificat sera téléchargé et enregistré dans `/etc/letsencrypt/`. Vous devriez voir une sortie similaire à ce qui suit :

```
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/example.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/example.com/privkey.pem
   Your cert will expire on 2021-09-27. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

Vous avez réussi à générer un certificat SSL wildcard ! L'étape suivante consiste à configurer votre application serveur pour l'utiliser. Nous vous indiquerons quelques ressources qui peuvent vous aider dans la section suivante.

## Conclusion

Dans ce tutoriel, vous avez configuré Certbot et téléchargé un certificat SSL wildcard depuis l'autorité de certification Let's Encrypt. Vous êtes maintenant prêt à configurer votre logiciel serveur pour utiliser ce certificat afin de sécuriser ses connexions.

Pour plus d'informations sur les fichiers de certificat téléchargés et sur la façon de redémarrer vos applications lorsque Certbot met automatiquement à jour vos certificats, consultez les étapes 3 et 4 de notre tutoriel [Comment utiliser le mode autonome de Certbot pour récupérer les certificats SSL de Let's Encrypt sur Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-use-certbot-standalone-mode-to-retrieve-let-s-encrypt-ssl-certificates-on-ubuntu-1804).

