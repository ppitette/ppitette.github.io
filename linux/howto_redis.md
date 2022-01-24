# Installation de Redis

```
sudo 
```

```conf
sudo vim /etc/redis/redis.conf
===============================================================================
port 0 # on désactive l'écoute TCP pour des raisons de sécurité
unixsocket /var/run/redis/redis-server.sock # on active le socket Unix
unixsocketperm 777
# logfile /var/log/redis/redis-server.log # on désactive le log fichier
syslog-enabled yes # on active le log syslog
syslog-ident redis
requirepass monPasswordSecurePourRedis # on définit un mot de passe pour Redis
rename-command CONFIG "" # on désactive la commande CONFIG
===============================================================================
```

```
sudo
```

