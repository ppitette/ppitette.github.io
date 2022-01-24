# Composer etc.

## Installation de Composer (en global)

```
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo php -r "unlink('composer-setup.php');"
```

```
composer --version
================================================================================
Composer version 2.0.11 2021-02-24 14:57:23
================================================================================
```

## Installation de Symfony-cli (en global)

```
wget https://get.symfony.com/cli/installer -O - | bash
sudo mv /home/adminsit/.symfony/bin/symfony /usr/local/bin/symfony
```

```
symfony --V
================================================================================
Symfony CLI version v4.23.2 (2021-03-02T17:16:03+0000 - stable)
================================================================================
```

## Installation de nodejs (en global)

```
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
sudo apt install nodejs
```

```
node -v
================================================================================
v15.12.0
================================================================================
```

## Installation de yarn (en global)

```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn
```

```
yarn -v
================================================================================
1.22.5
================================================================================
```