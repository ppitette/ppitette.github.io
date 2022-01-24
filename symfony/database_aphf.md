# Base de données de l'application APHF

## Entités

### Personne
Liste des Personnes quelque soit la nature de leur participation aux pèlerinages.

| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| titre                   | string(10)  | oui   |                        |
| nom                     | string(32)  |       |                        |
| prenom                  | string(32)  |       |                        |
| adresse1                | string(50)  |       |                        |
| adresse2                | string(50)  | oui   |                        |
| codePostal              | string(5)   |       |                        |
| commune                 | string(32)  |       |                        |
| dateNaissance           | date        | oui   |                        |
| tel                     | string(15)  | oui   |                        |
| portable                | string(15)  | oui   |                        |
| courriel                | string(50)  | oui   |                        |
| valid                   | string(3)   |       |                        |
| liea                    | int         | oui   |                        |
| old                     | int         | oui   |                        |
| secteur                 | ManyToOne   | oui   |                        |
| profSante               | ManyToOne   | oui   |                        |
| hospitaliers            | OneToMany   |       |                        |
| malades                 | OneToMany   |       |                        |
| pelerins                | OneToMany   |       |                        |

### Secteur
Entité liée à `Personne` servant :
* à identifier le secteur diocésain d'appartenance
* l'identité du responsable.

| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| section                 | string(60)  |       | nom du Secteur         |
| responsable             | OneToOne    |       |                        |
| personnes               | OneToMany   |       |                        |

### ProfSante
Entité liée à `Personne` servant à identifier les professionnels de santé.

| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| profession              | string(60)  |       |                        |
| old                     | int         | oui   |                        |
| personnes               | OneToMany   |       |                        |

### Transport
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| nom                     | string(30)  |       | unique                 |
| capacite                | int         | oui   |                        |
| compagnie               | string(50)  | oui   |                        |
| old                     | int         | oui   |                        |
| horaires                | OneToMany   |       |                        |

### Horaire
Anciennement nommée 'PasserPar', renommée par souci de cohérence avec les tables liées.

| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| heureAller              | date        | oui   |                        |
| heureRetour             | date        | oui   |                        |
| transport               | ManyToOne   |       |                        |
| gare                    | ManyToOne   |       |                        |
| pele                    | ManyToOne   |       |                        |

### Gare
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| nom                     | string(50)  |       | unique                 |
| web                     | boolean     |       |                        |
| old                     | int         | oui   |                        |
| horaires                | OneToMany   |       |                        |
| hospitaliers            | OneToMany   |       |                        |
| malades                 | OneToMany   |       |                        |
| pelerins                | OneToMany   |       |                        |

### Pele
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| libelle                 | string(30)  |       |                        |
| debut                   | date        |       |                        |
| fin                     | date        |       |                        |
| montantMalade           | float       | oui   |                        |
| montantCar              | float       | oui   |                        |
| montantVoiture          | float       | oui   |                        |
| montantJeune            | float       | oui   |                        |
| horaires                | OneToMany   |       | Mapped                 |
| hospitaliers            | OneToMany   |       | Mapped                 |
| malades                 | OneToMany   |       | Mapped                 |
| pelerins                | OneToMany   |       | Mapped                 |
| equipes                 | OneToMany   |       | Mapped                 |

### Hospitalier
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| nouveau                 | boolean     |       |                        |
| complet                 | boolean     |       |                        |
| dateArrivee             | date        | oui   |                        |
| dateDepart              | date        | oui   |                        |
| couple                  | boolean     |       |                        |
| conjoint                | string(50)  | oui   |                        |
| nomHeb                  | string(32)  | oui   |                        |
| chambreInd              | boolean     |       |                        |
| forfaitJeune            | boolean     |       |                        |
| desiderata              | string(255) | oui   |                        |
| capaciteRestreinte      | string(255) | oui   |                        |
| desiderataAff           | string(255) | oui   |                        |
| nuit1                   | boolean     |       |                        |
| nuit2                   | boolean     |       |                        |
| nuit3                   | boolean     |       |                        |
| parrain                 | string(40)  | oui   |                        |
| transport               | string(15)  |       |                        |
| voyageAvec              | string(40)  | oui   |                        |
| inscritWeb              | date        | oui   |                        |
| divers                  | text        | oui   |                        |
| paiementInsc            | boolean     |       |                        |
| montantInsc             | float       |       |                        |
| incomplet               | boolean     |       |                        |
| annuler                 | boolean     |       |                        |
| old                     | int         | oui   |                        |
| parrain_id              | ManyToOne   |       | (boucle)               |
| personne                | ManyToOne   |       | Inversed               |
| pele                    | ManyToOne   |       | Inversed               |
| gare                    | ManyToOne   |       | Inversed               |
| hebergement             | ManyToOne   |       | Inversed               |
| listeEquipe             | ManyToMany  |       | Inversed               |
| listeRespo              | ManyToMany  |       | Inversed               |
| affectation1            | ManyToOne   |       | Inversed               |
| affectation2            | ManyToOne   |       | Inversed               |
| affObtenues             | ManyToMany  |       | Inversed               |
| listeNuit               | ManyToMany  |       | Inversed               |
| listeModule             | ManyToMany  |       | Inversed               |
| listeIde                | ManyToMany  |       | Inversed               |
| listeHospit             | ManyToMany  |       | Inversed               |


### Malade
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| taille                  | float       | oui   |                        |
| poids                   | float       | oui   |                        |
| persPrevHosp            | boolean     |       |                        |
| persPrevFam             | boolean     |       |                        |
| persPrevTut             | boolean     |       |                        |
| persPrevPersConf        | boolean     |       |                        |
| persPrevNom             | string(30)  | oui   |                        |
| persPrevTel             | string(30)  | oui   |                        |
| medecinTraitant         | string(30)  | oui   |                        |
| telMedecin              | string(14)  | oui   |                        |
| telRetour               | string(14)  | oui   |                        |
| posVoyAssis             | boolean     |       |                        |
| posVoyCouche            | boolean     |       |                        |
| posVoyAssisFt           | boolean     |       |                        |
| posVoyElectrique        | boolean     |       |                        |
| monteMarchesCar         | boolean     |       |                        |
| deplaceSeul             | boolean     |       |                        |
| deplaceAide             | boolean     |       |                        |
| deplaceCanne            | boolean     |       |                        |
| deplaceDeambulateur     | boolean     |       |                        |
| deplaceFauteuil         | boolean     |       |                        |
| deplaceBrancard         | boolean     |       |                        |
| deplaceEscalier         | boolean     |       |                        |
| prothese                | boolean     |       |                        |
| deficitVision           | boolean     |       |                        |
| deficitAudition         | boolean     |       |                        |
| deficitParole           | boolean     |       |                        |
| deficitDesorientation   | boolean     |       |                        |
| deficitFugue            | boolean     |       |                        |
| regNormal               | boolean     |       |                        |
| regDiab                 | boolean     |       |                        |
| regSsSel                | boolean     |       |                        |
| regMix                  | boolean     |       |                        |
| regHache                | boolean     |       |                        |
| regPbDeglutition        | boolean     |       |                        |
| regEauGel               | boolean     |       |                        |
| regChambre              | boolean     |       |                        |
| regAideRepas            | boolean     |       |                        |
| parenterale             | boolean     |       |                        |
| soinInfInj              | boolean     |       |                        |
| soinInfInjType          | string(50)  | oui   |                        |
| soinInfInjHoraire       | string(50)  | oui   |                        |
| soinInfInsuline         | boolean     |       |                        |
| soinInfPansement        | boolean     |       |                        |
| soinInfPansementType    | string(50)  | oui   |                        |
| autreSoinSpec           | string(50)  | oui   |                        |
| autreSoinPriseMed       | boolean     |       |                        |
| autreSoinOxygene        | boolean     |       |                        |
| autreSoinOxygeneDebit   | string(50)  | oui   |                        |
| ppc                     | boolean     |       |                        |
| extracteur              | boolean     |       |                        |
| toiletteAideTotal       | boolean     |       |                        |
| toiletteAidePartielAvec | boolean     |       |                        |
| toiletteAidePartielSans | boolean     |       |                        |
| toiletteAideLit         | boolean     |       |                        |
| coucheAide              | boolean     |       |                        |
| coucheBarriereLit       | boolean     |       |                        |
| coucheBarrierePotence   | boolean     |       |                        |
| matelasAntiEsc          | boolean     |       |                        |
| coussinEsc              | boolean     |       |                        |
| souleveMalade           | boolean     |       |                        |
| incontBesChange         | boolean     |       |                        |
| incontJour              | boolean     |       |                        |
| incontNuit              | boolean     |       |                        |
| incontSondeUri          | boolean     |       |                        |
| incontEtuiPen           | boolean     |       |                        |
| incontPocheStom         | boolean     |       |                        |
| incontPocheStomType     | string(30)  | oui   |                        |
| dialyse                 | boolean     |       |                        |
| verticalisateur         | boolean     |       |                        |
| saisiPar                | string(30)  | oui   |                        |
| incomplet               | boolean     |       |                        |
| codification            | string(4)   | oui   |                        |
| paiementInsc            | boolean     |       |                        |
| montantInsc             | float       |       |                        |
| casParticulier          | boolean     |       |                        |
| divers                  | text        | oui   |                        |
| annuler                 | boolean     |       |                        |
| createdAt               | date        |       |                        |
| old                     | int         | oui   |                        |
| personne                | ManyToOne   |       |                        |
| pele                    | ManyToOne   |       |                        |
| gare                    | ManyToOne   |       |                        |
| chambre                 | ManyToOne   |       | Inversed               |

### Pelerin
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| nouveau                 | boolean     |       |                        |
| desiderata              | string(50)  | oui   |                        |
| couple                  | boolean     |       |                        |
| conjoint                | string(50)  | oui   |                        |
| modeHebergement         | string(25)  |       |                        |
| styleChambre            | string(25)  |       |                        |
| divers                  | text        | oui   |                        |
| paiementInsc            | boolean     |       |                        |
| montantInsc             | float       |       |                        |
| incomplet               | boolean     |       |                        |
| annuler                 | boolean     |       |                        |
| old                     | int         | oui   |                        |
| personne                | ManyToOne   |       |                        |
| pele                    | ManyToOne   |       |                        |
| gare                    | ManyToOne   |       |                        |
| hebergement             | ManyToOne   |       |                        |

### Hebergement
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| actif                   | boolean     |       |                        |
| libelle                 | string(100) |       | Unique                 |
| rue                     | string(100) | oui   |                        |
| cp                      | string(5)   | oui   |                        |
| ville                   | string(100) | oui   |                        |
| telephone               | string(14)  | oui   |                        |
| fax                     | string(14)  | oui   |                        |
| email                   | string(100) | oui   |                        |
| siteweb                 | string(100) | oui   |                        |
| prix                    | decimal     | oui   |                        |
| type                    | string(15)  |       |                        |
| old                     | int         | oui   |                        |
| hospitaliers            | OneToMany   |       |                        |
| pelerins                | OneToMany   |       |                        |

### Inscription
Anciennement nommée 'Inscrire', renommée par souci de cohérence avec les tables liées.

| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| entantque               | string(5)   |       |                        |
| prix                    | float       | oui   |                        |
| pele                    | ManyToOne   | oui   |                        |
| personne                | ManyToOne   | oui   |                        |
| hebergement             | ManyToOne   | oui   | Inversed               |
| horaireAller            | ManyToOne   | oui   |                        |
| horaireRetour           | ManyToOne   | oui   |                        |
| roles                   | OneToMany   |       |                        |

### Role
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| type                    | int         |       |                        |
| inscription             | ManyToOne   | oui   | Inversed               |

### Paiement
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| payeur                  | string(100) | oui   |                        |
| typePaiement            | string(40)  |       |                        |
| montant                 | float       |       |                        |
| remise                  | ManyToOne   | oui   | Inversed               |
| inscription             | ManyToOne   | oui   | Inversed               |

### Remise
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| libelle                 | string(100) |       |                        |
| montant                 | float       | oui   |                        |
| date                    | date        | oui   |                        |
| type                    | string(10)  |       |                        |
| paiement                | OneToMany   |       | Mapped                 |
| pele                    | ManyToOne   | oui   | Inversed               |

### Affectation
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| service                 | string(60)  |       | Unique                 |
| web                     | boolean     |       |                        |
| equipes                 | OneToMany   |       | Mapped                 |
| hospitAffect1           | OneToMany   |       | Mapped                 |
| hospitAffect2           | OneToMany   |       | Mapped                 |
| hospitAffectations      | ManyToMany  |       | Mapped                 |

### Equipe
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| libelle                 | string(60)  |       |                        |
| old                     | int         | oui   |                        |
| affectation             | ManyToOne   |       | Inversed               |
| pele                    | ManyToOne   |       | Inversed               |
| hospitEquipe            | ManyToMany  |       | Mapped                 |
| hospitRespo             | ManyToMany  |       | Mapped                 |

### Chambre
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| actif                   | boolean     |       |                        |
| libelle                 | string(60)  |       | Unique                 |
| num                     | smallint    |       |                        |
| ordre                   | smallint    |       |                        |
| lits                    | smallint    |       |                        |
| hebergement             | string(60)  |       |                        |
| etage                   | smallint    |       |                        |
| ascenseur               | string(1)   | oui   |                        |
| cote                    | string(6)   | oui   |                        |
| old                     | int         | oui   |                        |
| malades                 | OneToMany   |       | Mapped                 |
| module                  | ManyToOne   |       | Inversed               |

### Module
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| libelle                 | string(60)  |       |                        |
| etage                   | smallint    |       |                        |
| masque                  | smallint    |       |                        |
| old                     | int         | oui   |                        |
| chambres                | OneToMany   |       | Mapped                 |
| respModule              | ManyToMany  |       | Mapped                 |
| ideModule               | ManyToMany  |       | Mapped                 |
| hospitModule            | ManyToMany  |       | Mapped                 |

### Nuit
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| nuit                    | string(20)  |       |                        |
| hospitNuit              | ManyToMany  |       | Mapped                 |

### PlanAccnd
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| etage                   | smallint    |       |                        |
| masque                  | smallint    |       |                        |
| x                       | smallint    |       |                        |
| y                       | smallint    |       |                        |
| o                       | string(4)   |       |                        |
| b                       | smallint    | oui   |                        |
| n                       | smallint    | oui   |                        |

### User
| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| username                | string(180) |       | unique                 |
| role                    | json        |       |                        |
| password                | string()    |       |                        |
| email                   | string(180) |       |                        |
| fullname                | string(255) |       |                        |
| reset_token             | string(255) | oui   |                        |

### Tables de la partie 'Web Mobile' du projet.

### WebInscription (en cours)
Anciennement nommée 'Inscriptions', renommée en raison d'une trop grande proximité de nom avec l'entité Inscription.

| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| id                      | int         |       |                        |
| inscrit                 | boolean     |       |                        |
| envoye                  | boolean     |       |                        |
| titre                   | string(10)  |       |                        |
| nom                     | string(25)  |       |                        |
| prenom                  | string(25)  |       |                        |
| dateNaissance           | date        |       |                        |
| adresse1                | string(50)  |       |                        |
| adresse2                | string(50)  | oui   |                        |
| codePostal              | string(5)   |       |                        |
| commune                 | string(25)  |       |                        |
| tel                     | string(15)  | oui   |                        |
| portable                | string(15)  | oui   |                        |
| courriel                | string(50)  |       |                        |
| nouveau                 | boolean     |       |                        |
| complet                 | boolean     |       |                        |
| dateArrivee             | date        | oui   |                        |
| dateRetour              | date        | oui   |                        |
| voyageAvec              | string(50)  | oui   |                        |
| forfaitJeune            | boolean     |       |                        |
| desiderata              | string(100) | oui   |                        |
| couple                  | boolean     |       |                        |
| conjoint                | string(50)  | oui   |                        |
| nomHeb                  | string(25)  | oui   |                        |
| chambreInd              | boolean     |       |                        |
| capaciteRestreinte      | string(100) | oui   |                        |
| desiderataAff           | string(100) | oui   |                        |
| nuit1                   | boolean     |       |                        |
| nuit2                   | boolean     |       |                        |
| nuit3                   | boolean     |       |                        |
| divers                  | text        | oui   |                        |
| paiementInsc            | float       |       | => montantInsc         |
| date                    | date        |       |                        |
| demat                   | boolean     |       |                        |
| parrain                 | string(50)  | oui   |                        |
| old                     | int         | oui   |                        |
| personne                | ManyToOne   | oui   |                        |
| pele                    | ManyToOne   | oui   |                        |
| secteur                 | ManyToOne   |       |                        |
| profSante               | ManyToOne   | oui   |                        |
| gare                    | ManyToOne   | oui   |                        |
| hebergement             | ManyToOne   | oui   |                        |
| affectation1            | ManyToOne   | oui   |                        |
| affectation2            | ManyToOne   | oui   |                        |

#### WebMessage
Anciennement nommée 'Message', renommée par souci de cohérence avec le renommage de l'entité précédente.
Cette entité décrit un message destiné à être envoyé par voie électronique et non une table de la base de données 

| propriété               | type        | null  | caractéristique        |
| :---------------------- | :---------- | :---: | :--------------------- |
| dest                    |             |       |                        |
| mailExp                 |             |       |                        |
| nomExp                  |             |       |                        |
| objet                   |             |       |                        |
| pj                      |             |       |                        |
| sujet                   |             |       |                        |
