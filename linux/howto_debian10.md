# Installation Serveur Debian 10 (HP Proliant rack)

## Installation minimale du serveur

Copier le fichier .deb de firmware additionnel dans le répertoire firmware de la clé usb de boot

[howtoforge](https://www.howtoforge.com/tutorial/debian-minimal-server/)

Créer le compte root et adminsit (Administrateur)

## Compléments à l'installation

passer surperutilisateur (root) et installer les packages complémentaires

```bash
su -
adduser adminsit sudo
apt install sudo vim zsh git ntp ssh openssh-server zip arj unzip screenfetch curl
```

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

## Access SSH

```bash
sudo vim /etc/ssh/sshd_config
==========================================================================
(Port xxxx)

HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Logging
SyslogFacility AUTH
LogLevel INFO

# Authentication:
LoginGraceTime 120
PermitRootLogin no
StrictModes yes
==========================================================================
```

```bash
sudo service ssh restart
```

### Génération d'une cle sur la machine hôte

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### Copie de la cle sur le serveur

Dans le dossier utilisateur

```bash
mkdir -m 700 .ssh
vim .ssh/authorized_keys <== copier ce qui se trouve dans le fichier id_rsa.pub
chmod 600 .ssh/authorized_keys
```

Il est alors possible de passer le parametre PasswordAuthentication à no

## Ressources

[Formation Debian](https://formation-debian.viarezo.fr/)
