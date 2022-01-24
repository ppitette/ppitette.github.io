# Poste Dev WSL (Windows 11)

## Ubuntu en Français (CLI)

```zsh
sudo apt install language-pack-fr
sudo apt install manpages-fr
sudo apt-get install $(check-language-support)
sudo update-locale LANG=fr_FR.UTF-8 LANGUAGE=fr_FR

sudo apt install ca-certificates curl gnupg lsb-release wget libnss3-tools software-properties-common apt-transport-https
```

## Parametrage de Git

```zsh
git config --global user.email "ppitette@gmail.com"
git config --global user.name "Pascal Pitette"
```

## docker et docker-compose

installés avec Docker Desktop. voir :
https://nickjanetakis.com/blog/a-linux-dev-environment-on-windows-with-wsl-2-docker-desktop-and-more

si pb :

```zsh
sudo chmod 666 /var/run/docker.sock
```

## mise à jour et ajout de dépots

```zsh
sudo add-apt-repository ppa:ondrej/php
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt update
apt upgrade
```

## php8

```zsh
sudo apt install php8.0 php8.0-apcu php8.0-opcache php8.0-xdebug php8.0-curl php8.0-intl php8.0-gd php8.0-mbstring php8.0-mysql php8.0-sqlite3 php8.0-redis php8.0-xml php8.0-bz2 php8.0-zip php8.0-soap php8.0-memcached php8.0-bcmath libpcre3
```

## composer CLI

```zsh
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
```

## symfony CLI

```zsh
wget https://get.symfony.com/cli/installer -O - | bash
sudo mv /home/pascal/.symfony/bin/symfony /usr/local/bin/symfony
```

## NodeJS et Yarn

```zsh
sudo apt install nodejs yarn
```

## Installation du client github (linux)

```zsh
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

gh auth login
    ? What account do you want to log into? GitHub.com
    ? What is your preferred protocol for Git operations? HTTPS
    ? Authenticate Git with your GitHub credentials? Yes
    ? How would you like to authenticate GitHub CLI? Paste an authentication token
    Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
    The minimum required scopes are 'repo', 'read:org', 'workflow'.
    ? Paste your authentication token: ****************************************
    - gh config set -h github.com git_protocol https
    ✓ Configured git protocol
    ✓ Logged in as ppitette
```

## Cloner un dépot

```zsh
gh repo clone ppitette/hnde
cd hnde
composer install
yarn install
yarn encore dev
```

## Depuis un dépot existant

```zsh
git remote add origin https://github.com/ppitette/hnde.git
git branch -M main
git push -u origin main
```



```
pavi15cs
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
```
