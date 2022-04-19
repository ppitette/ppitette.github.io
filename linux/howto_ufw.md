# UFW (Uncomplicated Firewall)

## Installation

```bash
sudo apt install ufw
```

## Utilisation

### Activer / Désactiver UFW

L'outil UFW n'est pas activé par défaut, il vous faut donc avoir les droits administrateur en ligne de commande.

Vérifier le statut actuel :

```bash
sudo ufw status
```

État : actif ou inactif 

Activer UFW : (c'est à dire appliquer les règles définies) 

```bash
sudo ufw enable
```

Désactiver UFW : (c'est à dire ne plus appliquer les règles définies) 

```bash
sudo ufw disable
```

### Afficher l'état actuel des règles

```bash
sudo ufw status verbose
```

L'argument verbose est optionnel, cependant il est vivement recommandé car il permet d'afficher la direction du trafic dans les règles (IN : entrant, OUT : sortant) 

--------------------------------------------------------------------------------

## Autoriser l'accès en SSH
```bash
sudo ufw allow 'SSH'
```

## Liste des modules

```bash
sudo ufw app list
```

## Caractéristiques d'un module

```bash
sudo ufw app info 'WWW'
```

## Autoriser un serveur web

```bash
sudo ufw allow 'WWW'
```

## Autoriser un serveur web (en https)

```bash
sudo ufw allow 'WWW Secure'
```

ou

```bash
sudo ufw allow 'WWW Full'
```
