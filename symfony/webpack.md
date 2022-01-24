# Symfony Webpack Encore

## Installation

```
composer require symfony/webpack-encore-bundle
yarn install
```

## Sass

renommer le/les fichiers `assets/styles*.css` en `assets/styles*.scss`

Installer Sass :

```
yarn add dart-sass sass-loader --dev
```

dans `webpack.config.js`, décommenter la ligne :
//.enableSassLoader()

## PostCSS and autoprefixing

Installation

dans `webpack.config.js`, ajouter la ligne :
.enablePostCssLoader()

```
yarn add postcss-loader autoprefixer --dev
```

A la racine du projet, créer le fichier `postcss.config.js` :

```
module.exports = {
    plugins: {
        autoprefixer: {}
    }
}
```

## Bootstrap

```
yarn add bootstrap @fortawesome/fontawesome-free
```

Fichier `assets/styles/app.scss` :

```
/*
 * assets/styles/app.scss
 */

@import 'bootstrap'; <= ligne à ajouter

 .jumbotron {
     padding: 2rem 1rem;
     margin-bottom: 2rem;
     /* background-color: #607d8b; */
     border-radius: .3rem;
 }
```

Fichier `assets/app.js` :

```
/*
 * Welcome to your app's main JavaScript file!
 *
 * We recommend including the built version of this JavaScript file
 * (and its CSS file) in your base layout (base.html.twig).
 */

// any CSS you import will output into a single css file (app.css in this case)
import './styles/app.scss';

// start the Stimulus application
import './bootstrap';

import 'bootstrap/dist/js/bootstrap.bundle.min.js';    <= ligne à ajouter

import '@fortawesome/fontawesome-free/js/fontawesome'; <= ligne à ajouter
import '@fortawesome/fontawesome-free/js/solid';       <= ligne à ajouter
import '@fortawesome/fontawesome-free/js/regular';     <= ligne à ajouter
import '@fortawesome/fontawesome-free/js/brands';      <= ligne à ajouter
```

## Générer les assets

```
symfony run yarn encore dev
```

ou

```
symfony run -d yarn encore dev --watch
```

## Utilisation

```
usage encore [dev|prod|production|dev-server]

encore is a thin executable around the webpack or webpack-dev-server executables

Commands:
    dev        : runs webpack for development
       - Supports any webpack options (e.g. --watch)

    dev-server : runs webpack-dev-server
       - --host The hostname/ip address the webpack-dev-server will bind to
       - --port The port the webpack-dev-server will bind to
       - --hot  Enable HMR on webpack-dev-server
       - --keep-public-path Do not change the public path (it is usually prefixed by the dev server URL)
       - Supports any webpack-dev-server options

    production : runs webpack for production
       - Supports any webpack options (e.g. --watch)

    encore dev --watch
    encore dev-server
    encore production
```
