# Import d'un fichier CSV avec une commande Symfony

## La DATA c’est la clef

Hé oui c’est fini le temps ou les applications comptaient une centaine d’utilisateurs et 10 fiches de contenus.

Non, maintenant avec 3 milliards d’internautes, certains devraient venir sur votre appli et il faut être prêt à ingurgiter un gros paquet d’informations rapidement et de manière automatisée.

Alors aujourd’hui je vous propose une solution pour ingurgiter du gros, du gras, bien poilu, fichier CSV (testé avec un fichier 200K + lignes) depuis une simple commande Symfony et en utilisant Doctrine !

## Faut pas faire ça

Alors soyons clair dés le début, Doctrine n’est pas fait pour de l’import de masse. Concrètement dans les solutions préconisées on a :

* Envoyer directement un fichier SQL
* Envoyer un fichier CSV via la commande mysqlimport.

Seulement voilà, votre problème concerne plusieurs tables, vous avez besoin de vérifier toutes les données pour les ajouter / mettre à jour / supprimer mais seulement à certaines conditions et vous avez un bon paquet de relations qu’il faut mettre à jour avec les clefs étrangères et toute la clique. Du coup bosser avec Doctrine rendrait les choses beaucoup moins complexes.

Le problème avec doctrine c’est l’utilisation de la mémoire qui explose et votre processus qui s’arrête brutalement vous laissant seul et désemparé. Il existe cependant des astuces pour pallier à ce problème.

## Un exemple simple

Voilà la tête du dit fichier CSV qu’il vous faut importer dans votre application.

| email | firstname | lastname |
|:------|:----------|:---------|
| iron@man.com | Tony | Stark |

+ 200 k lignes !

Alors imaginons hein ! Oui c’est le CSV pour les enfants mais à vous de le complexifier à volonté, ça changera rien au fonctionnement.

Bon, passons aux choses sérieuses, voilà du code bien des familles on en parle juste après : `Acme\AcmeBundle\Command\ImportCommand.php`


```php
<?php

namespace Acme\AcmeBundle\Command;

use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Helper\ProgressBar;

use Acme\AcmeBundle\Entity\User;

class ImportCommand extends ContainerAwareCommand
{

    protected function configure()
    {
        // Name and description for app/console command
        $this
            ->setName('import:csv')
            ->setDescription('Import users from CSV file');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        // Showing when the script is launched
        $now = new \DateTime();
        $output->writeln('<comment>Start : ' . $now->format('d-m-Y G:i:s') . ' ---</comment>');
        
        // Importing CSV on DB via Doctrine ORM
        $this->import($input, $output);
        
        // Showing when the script is over
        $now = new \DateTime();
        $output->writeln('<comment>End : ' . $now->format('d-m-Y G:i:s') . ' ---</comment>');
    }
    
    protected function import(InputInterface $input, OutputInterface $output)
    {
        // Getting php array of data from CSV
        $data = $this->get($input, $output);
        
        // Getting doctrine manager
        $em = $this->getContainer()->get('doctrine')->getManager();

        // Turning off doctrine default logs queries for saving memory
        $em->getConnection()->getConfiguration()->setSQLLogger(null);
        
        // Define the size of record, the frequency for persisting the data and the current index of records
        $size = count($data);
        $batchSize = 20;
        $i = 1;
        
        // Starting progress
        $progress = new ProgressBar($output, $size);
        $progress->start();
        
        // Processing on each row of data
        foreach ($data as $row) {

            $user = $em->getRepository('AcmeAcmeBundle:User')
                       ->findOneByEmail($row['email']);
             
            // If the user doest not exist we create one
            if (!is_object($user)) {
                $user = new User();
                $user->setEmail($row['email']);
            }
            
            // Updating info
            $user->setLastName($row['lastname']);
            $user->setFirstName($row['firstname']);
      
            // Do stuff here !
  
            // Persisting the current user
            $em->persist($user);
            
            // Each 20 users persisted we flush everything
            if (($i % $batchSize) === 0) {

                $em->flush();
                // Detaches all objects from Doctrine for memory save
                $em->clear();
                
                // Advancing for progress display on console
                $progress->advance($batchSize);
        
                $now = new \DateTime();
                $output->writeln(' of users imported ... | ' . $now->format('d-m-Y G:i:s'));

            }

            $i++;
        }
    
        // Flushing and clear data on queue
        $em->flush();
        $em->clear();
    
        // Ending the progress bar process
        $progress->finish();
    }

    protected function get(InputInterface $input, OutputInterface $output) 
    {
        // Getting the CSV from filesystem
        $fileName = 'web/uploads/import/users.csv';
        
        // Using service for converting CSV to PHP Array
        $converter = $this->getContainer()->get('import.csvtoarray');
        $data = $converter->convert($fileName, ';');
        
        return $data;
    }
    
}
```

J’ai essayé de commenter un peu partout, c’est important les commentaires, bon là il y en a carrément trop mais c’est pour être  le plus clair possible. Alors dans l’ordre on a fait quoi ?

* On configure notre commande pour qu’au app/console elle apparaisse proprement
* Ensuite on utilise notre service qui transforme notre CSV en tableau et le rendre exploitable facilement (voir le code plus bas)
* Tout de suite derrière on prépare doctrine et on lui dit de ne pas mettre en log les requêtes SQL parce qu’on veut économiser notre mémoire
* On compte combien d’utilisateurs vont être importés et on dit qu’on va les importer tous les 20 occurrences (libre à vous de changer par rapport à votre besoin)
* On initialise ProgressBar. Vous connaissez pas ProgressBar ? Checkez donc, ça existe depuis Symfony 2.5 et ça envoie du steak.
* Après on tourne sur notre gros tableau et on fait ce qu’on veut avec les données et surtout avec doctrine. Mettez à jour des relations, supprimez en d’autres, vous êtes libres !
* Enfin à la fin d’un paquet de 20 occurrences on enregistre le tout et on passe au paquet de 20 suivants.

Le code correspondant au service est juste ici :

```php
<?php

namespace Acme\AcmeBundle\Services;

class ConvertCsvToArray {
    
    public function __construct()
    {
    }
    
    public function convert($filename, $delimiter = ',') 
    {
        if(!file_exists($filename) || !is_readable($filename)) {
            return FALSE;
        }
        
        $header = NULL;
        $data = array();
        
        if (($handle = fopen($filename, 'r')) !== FALSE) {
            while (($row = fgetcsv($handle, 1000, $delimiter)) !== FALSE) {
                if(!$header) {
                    $header = $row;
                } else {
                    $data[] = array_combine($header, $row);
                }
            }
            fclose($handle);
        }
        return $data;
    }
}
```

app\config\config.yml

```yaml
services:    
    import.csvtoarray:
        class: Acme\AcmeBundle\Services\ConvertCsvToArray
```

Enfin dans votre console, dans le dossier de votre projet Symfony taper la commande pour lancer l’import :

```bash
symfony console import:csv
```

Et voilà !

## Épilogue

J’ai testé ce script avec un CSV pour les grands et avec de fortes contraintes (suppression, mise à jour de relations et autres) et le résultat a été plus que satisfaisant.

Encore une fois cette solution n’est pas la bonne pour des problèmes de très très grosse ampleur. On atteint ici la limite de doctrine, un superbe outil, mais qui n’est pas destiné à tout faire. Pensez plus aux solutions MySQL évoquées plus haut pour les cas plus extrêmes !

Sinon je ne saurais conseiller de lancer ce script la nuit via un crontab et de s’envoyer le résultat par mail, pour l’admirer le lendemain plein de fierté.


## Commentaire

Par souci de performances, Doctrine explique très clairement qu’il ne faut jamais (JAMAIS) appeler flush dans une boucle.

De plus, il est possible d’éviter l’usage de ContainerAwareCommand (qui a accès sur l’ensemble du container et donc, qui est peu optimisé pour des appels uniques) et d’injecter directement soit l’EntityManagerInterface soit le Repository (sous Symfony 4+ notamment) afin de simplifier les appels et éviter un accès trop large aux ressources.
