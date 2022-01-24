# Installation de docker, docker-compose et portainer.io

## Installation de docker

```bash
sudo apt install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

## Installation de docker-compose

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

### Déplacement

La solution présentée ici est reprise de celle proposée par le site LinuxConfig.org. Elle vous indique comment migrer le dossier d'installation par défaut de Docker (qui est généralement `/var/lib/docker`) vers un autre dossier sur votre machine. Une raison qui pourrait motiver cette opération est le manque de place sur l'espace disque actuel. Le dossier /var/lib/ étant généralement sur la partition racine de votre système, il est toujours délicat d'étendre cette partition de façon triviale. Selon l'article original, cette solution devrait fonctionner pour tout système Ubuntu ou Debian. Cette solution a été testée par nos soins avec succès sur Ubuntu 16.04 et Docker 17.03. Nous ne garantissons pas qu'elle fonctionne sous d'autres environnements.

Avant toute chose, veillez à arrêter tous vos conteneurs actuels en cours d'exécution. Lors de cette migration, ni aucun de vos conteneurs ou ni aucune de vos images ne seront supprimés. Vous pouvez néanmoins effectuer des sauvegardes de conteneurs si vous préférez vous prémunir de tout risque.

Commencez par ouvrir une session en mode sudo. Ensuite, exécutez la commande suivante :

```bash
systemctl edit --full docker
```

Localisez la ligne suivante :

```
ExecStart=/usr/bin/docker daemon -H fd://
```

Editez cette ligne pour ajouter l'option `-g` avec le chemin du nouveau répertoire.

```
ExecStart=/usr/bin/docker daemon -g /new/path/docker -H fd://
```

Remplacer `/new/path/docker` par le chemin absolu du dossier de destination que vous souhaitez. Sauvegardez le fichier, puis redémarrez maintenant le démon Docker :

```bash
systemctl stop docker
```

Il est très important que le démon Docker docker soit complètement arrêté. La commande suivante ne doit produire aucune sortie si le démon est correctement arrêté !

```bash
ps aux | grep -i docker | grep -v grep
```

Si aucune sortie n'est produite par cette commande, rechargez le démon Docker avec la commande suivante :

```bash
systemctl daemon-reload
```

Une fois que c'est fait, vous devez créer le nouveau répertoire Docker et synchronisez vos données actuelles avec la commande rsync :

```bash
mkdir /new/path/docker
rsync -aqxP /var/lib/docker/ /new/path/docker
```

Le dossier `/var/lib/docker` de la commande ci-dessous est à remplacer par le dossier actuel d'installation Docker. C'est le dossier par défaut, à moins que vous n'ayez auparavant déjà effectué une migration. Vous pouvez désormais démarrer le démon Docker :

```bash
systemctl start docker
```

Executez cette commande pour vérifier que le démon Docker s'est lancé avec la nouvelle option -g :

```bash
ps aux | grep -i docker | grep -v grep
```

```
root      2095  0.2  0.4 664472 36176 ?        Ssl  18:14   0:00 /usr/bin/docker daemon -g  /new/path/docker -H fd://
root      2100  0.0  0.1 360300 10444 ?        Ssl  18:14   0:00 docker-containerd -l /var/run/docker/libcontainerd/docker-containerd.sock --runtime docker-runc
```

## Installation de portainer

https://www.danielmartingonzalez.com/en/docker-and-portainer-in-debian/

```bash
docker volume create portainer_data
docker run -d --name=portainer -p 8000:8000 -p 9443:9443 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -e TZ='Europe/Paris' cr.portainer.io/portainer/portainer-ce
```
