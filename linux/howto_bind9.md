# Serveur DNS

## Installation

```
sudo apt install bind9 bind9utils bind9-doc dnsutils
```

## Configuration

### Modifier le fichier /etc/resolv.conf

```
sudo vim /etc/resolv.conf
```

```
domain pitette.lan
search pitette.lan
nameserver 192.168.1.11
```

### Adapter le fichier /etc/bind/named.conf.options

```
sudo cp /etc/bind/named.conf.options /etc/bind/named.conf.options_ori
sudo nano /etc/bind/named.conf.options
```

```
acl "trusted" {
    192.168.1.0/24;
};

options {
    directory "/var/cache/bind";

    // If there is a firewall between you and nameservers you want
    // to talk to, you may need to fix the firewall to allow multiple
    // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

    // If your ISP provided one or more IP addresses for stable
    // nameservers, you probably want to use them as forwarders.
    // Uncomment the following block, and insert the addresses replacing
    // the all-0's placeholder.

    recursion yes;
    allow-recursion { trusted; };
    listen-on { 192.168.1.11; };
    allow-transfer { none; };

    forwarders {
        1.1.1.2;
        1.0.0.2;
    };

    //========================================================================
    // If BIND logs error messages about the root key being expired,
    // you will need to update your keys.  See https://www.isc.org/bind-keys
    //========================================================================
    dnssec-validation auto;

    auth-nxdomain no;    # conform to RFC1035

    listen-on-v6 { any; };
    listen-on { any; };
};
```

### Adapter le fichier /etc/bind/named.conf.local

```
sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local_ori
sudo nano /etc/bind/named.conf.local
```

```
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";

zone "pitette.lan" {
    type master;
    file "/etc/bind/db.pitette.lan";
    allow-update { none; };
};

zone "1.168.192.in-addr-arpa" {
    type master;
    file "/etc/bind/db.pitette.rev";
    allow-update { none; };
};
```

### Créer le fichier /etc/bind/db.pitette.lan.hosts

```
sudo nano /etc/bind/db.pitette.lan.hosts
```

```
; /etc/bind/db.pitette.lan
$TTL    86400
@       IN      SOA     tleilax.pitette.lan. root.pitette.lan. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@        IN      NS      tleilax.pitette.lan.
router   IN      A       192.168.1.1
netgear  IN      A       192.168.1.2
ilosrv   IN      A       192.168.1.3
hpmfp    IN      A       192.168.1.5
caladan  IN      A       192.168.1.9
arrakis  IN      A       192.168.1.10
tleilax  IN      A       192.168.1.11
lgnas    IN      A       192.168.1.12
nasyno01 IN      A       192.168.1.13
station  IN      A       192.168.1.20
hpenvy15 IN      A       192.168.1.21
```

### Créer le fichier /etc/bind/db.pitette.lan.rev

```
sudo nano /etc/bind/db.pitette.rev
```

```
$TTL    86400
@       IN      SOA     tleilax.pitette.lan. root.pitette.lan. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
                NS      tleilax.pitette.lan.

1               PTR     router.pitette.lan.
2               PTR     netgear.pitette.lan.
3               PTR     ilosrv.pitette.lan.
5               PTR     hpmfp.pitette.lan.
9               PTR     caladan.pitette.lan.
10              PTR     arrakis.pitette.lan.
11              PTR     tleilax.pitette.lan.
12              PTR     lgnas.pitette.lan.
13              PTR     nasyno01.pitette.lan.
20              PTR     station.pitette.lan.
21              PTR     hpenvy15.pitette.lan.
```

```
sudo named-checkconf /etc/bind/named.conf
sudo named-checkzone 1.168.192.in.addr.arpa /etc/bind/db.pitette.rev
sudo named-checkzone pitette.lan /etc/bind/db.pitette.lan
```

## Redémarrage du serveur

```
sudo service bind9 restart
```

Vérifier le bon fonctionnement du service :
