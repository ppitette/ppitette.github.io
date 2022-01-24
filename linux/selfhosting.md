# Guide complet avec exemples pour l'auto-hébergement en utilisant docker. Traefik v2, Bitwarden, Wireguard+Pihole, Synapse+Elements, Jellyfin, Nextcloud, Backups, etc.

Je m'auto-héberge depuis un certain temps maintenant et j'utilise Docker depuis quelques années. Jusqu'à présent, ça marche très bien, et j'ai pensé que je pourrais partager comment j'utilise Docker pour auto-héberger facilement mes services préférés.

Un certain nombre de services sont expliqués dans ce guide :
* Traefik comme reverse proxy et gestionnaire SSL, c'est le cœur de cette infrastructure, sans doute l'exemple le plus détaillé.
* Bitwarden, Wirehole, Synapse+Element, Nextcloud, Jellyfin,... Une multitude de services pour s'auto-héberger, n'hésitez pas à choisir vos préférés.
* Sauvegardes avec un script bash personnalisé et testé
* Mise à jour avec watchtower
* Messages de notifications avec un gotify hébergé par le client !

https://github.com/BaptisteBdn/docker-selfhosted-apps

Ce guide est rempli d'exemples et presque tous les services sont prêts à être utilisés, le plus difficile étant Traefik car vous devez ajouter la configuration de votre fournisseur DNS. Un simple clone git, ainsi que la modification du fichier .env devraient suffire pour vous permettre de commencer votre voyage vers l'auto-hébergement.

La seule chose qui n'utilise pas Docker est la stratégie de sauvegarde car elle utilise des scripts bash personnalisés. Je l'utilise depuis quelques mois pour télécharger mes sauvegardes cryptées sur AWS, et cela fonctionne très bien. Le processus de restauration de la sauvegarde a également été testé à quelques reprises.

J'ai essayé d'inclure autant de références que possible et d'inclure également la sécurité, car elle peut être facilement négligée lors de l'auto-hébergement.

Ce guide peut être utile pour les débutants ainsi que pour les auto-hébergeurs expérimentés qui cherchent à migrer vers Docker, ou si vous êtes juste intéressé à voir comment Docker fonctionne.
