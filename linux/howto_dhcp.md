# Serveur DHCP

## Installation

```bash
sudo apt install isc-dhcp-server
```

## Configuration

Mentionner l'interface réseau sur laquelle le serveur sera actif
(voir dans le fichier /etc/netwwork/interface)

sudo vim /etc/default/isc-dhcp-server

```bash
INTERFACESV4="enp3s5"
```

Adapter le fichier de configuration du serveur

```bash
sudo mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf_ori
sudo nano /etc/dhcp/dhcpd.conf
```

# dhcpd.conf

# option definitions common to all supported networks...

```bash
option domain-name "pitette.lan";
option domain-name-servers 192.168.1.10;
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.1.255;
option routers 192.168.1.1;

default-lease-time 600;
max-lease-time 7200;

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
#log-facility local7;

subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.100 192.168.1.150;
    option routers 192.168.1.1;
}

host netgear {
    hardware ethernet B6:B9:8A:4B:E4:55;
    fixed-address 192.168.1.2;
    option host-name "netgear";
}

host ilosrv {
    hardware ethernet B4:B5:2F:67:1E:B6;
    fixed-address 192.168.1.3;
    option host-name "ilosrv";   
}

host kaitan {
    hardware ethernet B4:B5:2F:65:76:A4;
    fixed-address 192.168.1.9;
    option host-name "kaitan.pitette.lan";
}

host arrakis {
    hardware ethernet 00:22:15:BF:1A:AD;
    fixed-address 192.168.1.10;
    option host-name "arrakis.pitette.lan";
}

host lgnas {
    hardware ethernet 00:E0:91:80:AC:F7;
    fixed-address 192.168.1.12;
    option host-name "lgnas.pitette.lan";
}

host synas {
    hardware ethernet 00:11:32:82:F6:0A;
    fixed-address 192.168.1.13;
    option host-name "synas.pitette.lan";
}

host librelec {
    hardware ethernet 00:01:2E:70:3A:16;
    fixed-address 192.168.1.15;
    option host-name "librelec.pitette.lan";
}

host station {
    hardware ethernet 44:8A:5B:59:93:BE;
    fixed-address 192.168.1.21;
    option host-name "station.pitette.lan";
}
```

## Lancement du serveur

```bash
sudo service isc-dhcp-server start
```

Vérifier le bon fonctionnement du service :

```bash
sudo tail -n 30 /var/log/syslog
```

