# WSL2 Installation
https://blog.arcoptimizer.com/wsl2-guide-du-developpeur-du-sous-systeme-windows-pour-linux-2

```
wsl --install
```

## WSL2 Utilisation

### Lister les machines virtuelles

```
wsl --list --verbose
```

### Définir une distribution par défaut

```
wsl --setdefault <DistributionName>
```

### Désinscrire et réinstaller une distribution

```
wsl --unregister <DistributionName>
```

### Exécuter en tant qu’utilisateur spécifique

```
wsl --user <Username>
```

### Modifier l’utilisateur par défaut pour une distribution

```
<DistributionName> config --default-user <Username>
```

## Fichier /etc/wsl.conf

```
# Enable extra metadata options by default
[automount]
enabled = true
root = /windir/
options = "metadata,umask=22,fmask=11"
mountFsTab = false

# Enable DNS – even though these are turned on by default, we'll specify here just to be explicit.
[network]
generateHosts = true
generateResolvConf = true
```

## WSL2 Accès depuis l'explorateur

```
\\wsl$
```
