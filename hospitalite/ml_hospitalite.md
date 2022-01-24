http://www.mailjet.com/
https://fr.mailjet.com/
contact@hnde.org
mailjet@evreux.catholique.fr
Dio16evreux27000*

Hospitalité Notre Dame d'Évreux
communication@hnde.org

Template
--------
Arrière plan général : #f2f2e6 (#f4f4f4f)
Arrière plan mail    : #e5e9ff
Séparations          : #0000ff

À ce soir

Réseaux sociaux :
https://www.facebook.com/hospitalitenotredamedevreux/
https://www.instagram.com/hnde27/


Association Diocésaine
----------------------
Identifiant SIREN : 780 806 469
Identifiant SIRET du siège : 780 806 469 00380
TVA Intracommunautaire : FR78780806469

Centre Saint Jean
11bis rue Jean Bart
CS 40165
27001 Évreux Cedex

https://www.facebook.com/Chefclub.tv/videos/259247091272394/

Bleu Logo : #0083B4

#f39c12

https://evreux.catholique.fr/agenda/bdd-donnees/services/pelerinage/inscription-lourdes-19.pdf

## Mise à jour de la bdd mariadb

### prise en compte d'une désinscription

```sql
UPDATE hnde_personne SET lr_courriel = TRUE WHERE hnde_personne.courriel = 'simondubus@sfr.fr';
```

### export de la mailing-list depuis la bdd

```sql
SELECT db_personne.courriel, db_personne.nom, db_personne.prenom, db_personne.liste, db_personne.date_naiss, db_personne.d_pele FROM db_personne WHERE db_personne.courriel IS NOT NULL AND db_personne.lr_courriel IS FALSE AND db_personne.decede IS FALSE;
```

### Mise à jour du champ courriel

```sql
-- Contrôle
SELECT db_personne.liste, db_personne.nom, db_personne.prenom, db_personne.lr_courriel, db_personne.courriel FROM `db_personne` WHERE `courriel` = '';

-- Mise à jour
UPDATE db_personne SET db_personne.courriel = NULL WHERE db_personne.courriel = '';
```

### Hospitaliers 18-30

```sql
SELECT db_personne.liste, db_personne.nom, db_personne.prenom, YEAR(NOW())-YEAR(db_personne.date_naiss) AS age FROM `db_personne` WHERE YEAR(NOW())-YEAR(db_personne.date_naiss) <= 30 AND db_personne.liste = 'HOSP';
```

### Hospitaliers décédés

```sql
SELECT db_personne.liste, db_personne.nom, db_personne.prenom, db_personne.date_deces, db_personne.date_naiss, YEAR(db_personne.date_deces)-YEAR(db_personne.date_naiss) AS age FROM `db_personne` WHERE db_personne.decede = TRUE;
```

```sql
SELECT db_personne.id, db_personne.civilite, db_personne.nom, db_personne.prenom, db_personne.date_naiss, db_personne.decede, db_personne.date_deces FROM `db_personne`;
```
