# Configuration de Samba en tant que contrôleur de domaine Active Directory

Il est chois d'utiliser bind9 pour le DNS

## Installation de bind9

```
sudo apt install bind9 bind9utils bind9-doc dnsutils
```

Fichier /etc/network/interfaces
```
sudo vim /etc/network/interfaces
==========================================================================
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto bond0
iface bond0 inet static
    address 192.168.1.9
    netmask 255.255.255.0
    network 192.168.1.0
    broadcast 192.168.1.255
    gateway 192.168.1.1
    slaves enp3s0f0 enp3s0f1 enp4s0f0 enp4s0f1
    bond-mode active-backup
    bond-miimon 100
    bond-downdelay 200
    bond-updelay 200
==========================================================================
```

Fichier /etc/hosts
```
sudo vim /etc/hosts
==========================================================================
127.0.0.1       localhost.localdomain   localhost
192.168.1.9     kaitan.pitette.lan      kaitan

# The following lines are desirable for IPv6 capable hosts
#::1     localhost ip6-localhost ip6-loopback
#ff02::1 ip6-allnodes
#ff02::2 ip6-allrouters
==========================================================================
```

Fichier /etc/hostname
```
sudo vim /etc/hostname
==========================================================================
kaitan.pitette.lan
==========================================================================
```

## Installation de Samba4

```
sudo apt install acl attr samba samba-dsdb-modules samba-vfs-modules winbind libpam-winbind libnss-winbind libpam-krb5 krb5-config krb5-user
```

Modification du fichier /etc/krb5.conf
(supprimer tout ce qu'il y a dedans et rajouter les lignes suivantes. Attention de bien mettre le nom du domaine en majuscule.)

```
sudo mv /etc/krb5.conf /etc/krb5.conf.ori
sudo vim /etc/krb5.conf
==========================================================================
[libdefaults]
    dns_lookup_realm = false
    dns_lookup_kdc = true
    default_realm = PITETTE.LAN
==========================================================================
```

Effacer le fichier /etc/samba/smb.conf s'il a déjà été généré
(il va être régénéré par la commande de provisionning samba-tool juste après)

```
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.ori
```

```
samba-tool domain provision --use-rfc2307 --interactive
==========================================================================
Realm [EXAMPLE.COM]: PITETTE.LAN
Domain [EXAMPLE]: PITETTE
Server Role (dc, member, standalone) [dc]: dc
DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERNAL]: BIND9_DLZ
DNS forwarder IP address (write 'none' to disable forwarding) [192.0.2.1]: 192.168.1.1
Administrator password:
Retype password:
==========================================================================
```

Pour changer le mot de passe administratuer :
```
samba-tool user setpassword administrator
```

Configurer le DNS pour pointer sur lui même dans le fichier /etc/resolv.conf en renseignant 127.0.0.1.

```
vim /etc/resolv.conf
==========================================================================
domain mondomaine.lan
search mondomaine.lan
nameserver 127.0.0.1
==========================================================================
```

Vérifier que les forwarders DNS ont bien été configurés dans le fichier /etc/samba/smb.conf
```
vim /etc/samba/smb.conf
==========================================================================
domain mondomaine.lan
search mondomaine.lan
nameserver 127.0.0.1
==========================================================================
```

Par défaut, sous Debian le paquet samba utilise le service samba-ad-dc et non plus le service samba. 

```
systemctl unmask samba-ad-dc
systemctl enable samba-ad-dc
systemctl disable samba winbind nmbd smbd
systemctl mask samba winbind nmbd smbd
reboot
```

```
samba-tool processes
```