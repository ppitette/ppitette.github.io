# Agrégation de liens (bonding)

## Installation

```bash
sudo apt install ifenslave
```

## Configuration de l'interface

```bash
sudo vim /etc/network/interfaces
==========================================================================
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp3s0f0
iface enp3s0f0 inet manual
    bond-master bond0
-
auto enp3s0f1
iface enp3s0f1 inet manual
    bond-master bond0
-
auto enp4s0f0
iface enp4s0f0 inet manual
    bond-master bond0
-
auto enp4s0f1
iface enp4s0f1 inet manual
    bond-master bond0

auto bond0
iface bond0 inet static
    address 192.168.1.10
    netmask 255.255.255.0
    network 192.168.1.0
    broadcast 192.168.1.255
    gateway 192.168.1.1

# The primary network interface
#auto enp3s0f0
#iface enp3s0f0 inet static
#    address 192.168.1.9
#    netmask 255.255.255.0
#    network 192.168.1.0
#    broadcast 192.168.1.255
#    gateway 192.168.1.1

# This is an autoconfigured IPv6 interface
#iface enp3s0f0 inet6 auto
==========================================================================
```

## Activation

```bash
service networking stop
service networking start
```
