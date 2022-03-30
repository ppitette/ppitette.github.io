# Configurer un certificat SSL (Let's Encrypt) pour Apache

```bash
sudo apt install python-certbot-apache -t buster-backports
```

```bash
sudo certbot --apache -d hnde.org -d www.hnde.org
```

```bash
sudo certbot certonly --webroot -w /var/www/hnde --agree-tos --no-eff-email --email webmaster@hnde.org -d appli.hnde.org --rsa-key-size 4096
```

```bash
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator webroot, Installer None
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for cloud.mondomaine.com
Using the webroot path /var/www/nextcloud for all unmatched domains.
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/cloud.mondomaine.com/fullchain.pem.
   Your key file has been saved at:
   /etc/letsencrypt/live/cloud.mondomaine.com/privkey.pem
   Your cert will expire on 20XX-XX-XX. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run "certbot
   renew"
 - Your account credentials have been saved in your Certbot
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Certbot so
   making regular backups of this folder is ideal.
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

sudo apt install -y software-properties-common
sudo apt install -y certbot
sudo certbot certonly --webroot -w /var/www/nextcloud --agree-tos --no-eff-email --email email@mondomaine.com -d cloud.mondomaine.com --rsa-key-size 4096
