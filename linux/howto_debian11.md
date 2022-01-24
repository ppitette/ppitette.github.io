# Installation Serveur Debian 10 (HP Proliant rack)

## Installation minimale du serveur

Copier le fichier .deb de firmware additionnel dans le répertoire firmware de la clé usb de boot

[howtoforge](https://www.howtoforge.com/tutorial/debian-minimal-server/)

Créer le compte root et adminsit (Administrateur)

## Configuration réseau (IP fixe)

```bash
sudo nano /etc/network/interfaces
==========================================================================
# The primary network interface
allow-hotplug enp3s0f0
iface enp3s0f0 inet static
    address 192.168.1.9
    netmask 255.255.255.0
    network 192.168.1.0
    broadcast 192.168.1.255
    gateway 192.168.1.1
==========================================================================
```

```bash
sudo nano /etc/hosts
==========================================================================
127.0.0.1      localhost.localdomain    localhost
192.168.1.10   caladan.pitette.lan      caladan
```

```bash
sudo nano /etc/hostname
==========================================================================
caladan
```

## Compléments

passer surperutilisateur (root) et installer les packages complémentaires

```bash
su -
adduser adminsit sudo
apt install sudo vim zsh git ntp ssh openssh-server zip arj unzip screenfetch curl
```

## Config Zsh et Vim

```bash
wget https://formation-debian.viarezo.fr/fichiers-config.tar.gz
tar xvzf fichiers-config.tar.gz
cd fichiers-config
cp vimrc /etc/vim/
cp zshrc zshenv zlogin zlogout /etc/zsh/
cp dir_colors /etc/
```

Dans le fichier '/etc/zsh/zshenv', commenter le cas échéant la ligne :

```bash
export GREP_OPTIONS='--color=auto'
```

pour éviter l'erreur :
[[ ! ]] grep: warning: GREP_OPTIONS is deprecated; please use an alias or script

Supprimer les fichiers qui figurent dans le répertoire '/etc/skel'

```bash
sudo vim /etc/adduser.conf
chsh <= /bin/zsh
```

## Ressources

[Formation Debian](https://formation-debian.viarezo.fr/)
