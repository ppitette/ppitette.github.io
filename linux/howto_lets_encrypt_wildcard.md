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

Étape 1 - Configuration du Wildcard DNS

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
$ host one.example.com
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
