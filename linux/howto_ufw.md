# UFW (Uncomplicated Firewall)

## Installation

```zsh
sudo apt install ufw
```

## Utilisation

### Activer / Désactiver UFW

L'outil UFW n'est pas activé par défaut, il vous faut donc avoir les droits administrateur en ligne de commande.

Vérifier le statut actuel :

```zsh
sudo ufw status
```

État : actif ou inactif 

Activer UFW : (c'est à dire appliquer les règles définies) 

```zsh
sudo ufw enable
```

Désactiver UFW : (c'est à dire ne plus appliquer les règles définies) 

```zsh
sudo ufw disable
```

### Afficher l'état actuel des règles

```zsh
sudo ufw status verbose
```

L'argument verbose est optionnel, cependant il est vivement recommandé car il permet d'afficher la direction du trafic dans les règles (IN : entrant, OUT : sortant) 

--------------------------------------------------------------------------------

## Autoriser l'accès en SSH
```zsh
sudo ufw allow 'SSH'
```

## Liste des modules

```zsh
sudo ufw app list
```

## Caractéristiques d'un module

```zsh
sudo ufw app info 'WWW'
```

## Autoriser un serveur web

```zsh
sudo ufw allow 'WWW'
```

## Autoriser un serveur web (en https)

```zsh
sudo ufw allow 'WWW Secure'
```

ou

```zsh
sudo ufw allow 'WWW Full'
```
