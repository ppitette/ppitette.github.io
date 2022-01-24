# Installer le dispositif permettant de préfixer les tables de la DBB

[Documentation](https://www.doctrine-project.org/projects/doctrine-orm/en/2.6/cookbook/sql-table-prefixes.html "doc Doctrine")

## Modifier les fichiers .env et .env.local
Ajouter dans les deux fichiers la ligne suivante :

```
DATABASE_PREFIX=xxxx
```

## Fichier config/services.yaml
Ajouter les lignes suivantes 

```json
==========================================================================
App\Doctrine\TablePrefix:
        arguments:
            $prefix: '%env(string:DATABASE_PREFIX)%'
        tags:
            - { name: doctrine.event_subscriber, connection: default }
==========================================================================
```

## Fichier src/Doctrine/TablePrefix.php

```php
==========================================================================
<?php

namespace App\Doctrine;

use Doctrine\Common\EventSubscriber;
use Doctrine\ORM\Event\LoadClassMetadataEventArgs;

class TablePrefix implements EventSubscriber
{
    protected $prefix = '';

    public function __construct(string $prefix)
    {
        $this->prefix = $prefix;
    }

    public function getSubscribedEvents()
    {
        return ['loadClassMetadata'];
    }

    public function loadClassMetadata(LoadClassMetadataEventArgs $eventArgs)
    {
        $classMetadata = $eventArgs->getClassMetadata();

        if (!$classMetadata->isInheritanceTypeSingleTable() || $classMetadata->getName() === $classMetadata->rootEntityName) {
            $classMetadata->setPrimaryTable([
                'name' => $this->prefix . '_' . $classMetadata->getTableName()
            ]);
        }

        foreach ($classMetadata->getAssociationMappings() as $fieldName => $mapping) {
            if ($mapping['type'] == \Doctrine\ORM\Mapping\ClassMetadataInfo::MANY_TO_MANY && $mapping['isOwningSide']) {
                $mappedTableName = $mapping['joinTable']['name'];
                $classMetadata->associationMappings[$fieldName]['joinTable']['name'] = $this->prefix . $mappedTableName;
            }
        }
    }
}
==========================================================================
```
