# Installing the Guest Additions on a GUI-less server

1. Start VirtualBox
2. Start the host in question
3. Once the host has booted, click Devices | Insert Guest Additions CD Image
4. Log in to your guest server
5. Mount the CD-ROM with the command sudo mount /dev/cdrom /media/cdrom
6. Change into the mounted directory with the command cd /media/cdrom
7. Install the necessary dependencies with the command sudo apt install -y dkms build-essential linux-headers-$(uname -r)
8. Change to the root user with the command sudo su
9. Install the Guest Additions package with the command ./VBoxLinuxAdditions.run
10. Allow the installation to complete

Reboot your machine, and the Guest Additions will be working.

# Espace partagé

vboxsf

# Convertir un disque virtuel VHD en VDI

Passer par l’interface de virtualbox.
Dans le « gestionnaire de média virtuels » (ctrl+D).
– Ajouter le fichier VHD. (ctrl+shift+A)
– utiliser le fonction copie de la même interface (ctrl+shift+C)

Avantage le nouveaux disque virtuel est directement fonctionnelle (testé avec winXP), et en plus le compactage est fait en même temps. (du moment que l’espace vide à été nettoyer avant)
