# Authentification sans le FOSUserBundle

## Création de l'entité User
```
php bin/console make:user
==========================================================================
The name of the security user class (e.g. User) [User]:
> User

Do you want to store user data in the database (via Doctrine)? (yes/no) [yes]:
> yes

Enter a property name that will be the unique "display" name for the user (e.g. email, username, uuid) [email]:
> email

Will this app need to hash/check user passwords? Choose No if passwords are not needed or will be checked/hashed by some other system (e.g. a single sign-on server).
Does this app need to hash/check user passwords? (yes/no) [yes]:
> yes

The newer Argon2i password hasher requires PHP 7.2, libsodium or paragonie/sodium_compat. Your system DOES support this algorithm.
You should use Argon2i unless your production system will not support it.
Use Argon2i as your password hasher (bcrypt will be used otherwise)? (yes/no) [yes]:
> no
==========================================================================
```

## Modification de l'entité User
Récupérer le script User.php

## Créer la table dans la base de données
```
php bin/console make:migration
php bin/console doctrine:migrations:migrate
```

## DataFixtures
Créer l'utilitaire d'insertion des données d'essai

```
php bin/console make:fixtures
==========================================================================
The class name of the fixtures to create (e.g. AppFixtures):
> UserFixtures

created: src/DataFixtures/UserFixtures.php
==========================================================================
```

Récupérer le script UserFixtures.php

Créer un jeu d'utilisateurs
```
php bin/console doctrine:fixtures:load
==========================================================================
Careful, database will be purged. Do you want to continue y/N ?y
> purging database
> loading App\DataFixtures\UserFixtures
==========================================================================
```

## Fichier config/packages/security.yaml
Récupérer le script

## Authentification
Créer le login_form
```
php bin/console make:auth
==========================================================================
What style of authentication do you want? [Empty authenticator]:
 [0] Empty authenticator
 [1] Login form authenticator
> 1

The class name of the authenticator to create (e.g. AppCustomAuthenticator):
> LoginFormAuthenticator

Choose a name for the controller class (e.g. SecurityController) [SecurityController]:
>

created: src/Security/LoginFormAuthenticator.php
updated: config/packages/security.yaml
created: src/Controller/SecurityController.php
created: templates/security/login.html.twig

Success!

Next:
- Customize your new authenticator.
- Finish the redirect "TODO" in the App\Security\LoginFormAuthenticator::onAuthenticationSuccess() method.
- Review & adapt the login template: templates/security/login.html.twig.
==========================================================================
```

Modifier la méthode ```onAuthenticationSuccess()``` du ```LoginFormAuthenticator``` :
```
==========================================================================
return new RedirectResponse($this->urlGenerator->generate('home'));
==========================================================================
```

Adapter les templates :
templates/security/login.twig.html


## Fichier config/services.yaml
Ajouter les lignes suivantes 
```
dans la partie services
==========================================================================
    App\EventSubscriber\RegistrationNotifySubscriber:
        $sender: '%app.email_sender%'
==========================================================================
```

Récupérer :
EventSubscriber/RegistrationNotifySubscriber.php
Events.php
