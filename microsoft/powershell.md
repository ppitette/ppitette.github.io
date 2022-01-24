# Powershell

# Modifier la stratégie d’exécution

```
Get-ExecutionPolicy -List
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Création du profil powershell :

```
notepad $PROFILE
----------------------------------------
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox
----------------------------------------
```

## Modification du theme

```
Set-Theme paradox
Set-Theme agnoster
```
