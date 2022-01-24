# Base de données de l'application HNDE

id
remise
compLoc
numVoie
typeVoie
nomVoie
compVoie
insee
cPostal
commune
pays
lat
lng

paroisse
secteur
diocese

## Entités

### hnde_inscription
description de la table :

Inscriptions au pèlerinage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| pele_id         | int(11)      | NO   | MUL | NULL    |                |
| pelerin_id      | int(11)      | NO   | MUL | NULL    |                |
| numsdp          | int(11)      | NO   |     | NULL    |                |
| dos_enreg       | datetime     | NO   |     | NULL    |                |
| entite          | int(11)      | NO   |     | NULL    |                |
| couple          | varchar(50)  | YES  |     | NULL    |                |
| dos_envoi       | datetime     | YES  |     | NULL    |                |
| dos_retour      | datetime     | YES  |     | NULL    |                |
| insc_statut     | int(11)      | NO   |     | NULL    |                |
| voy_aller       | tinyint(1)   | NO   |     | NULL    |                |
| voy_retour      | tinyint(1)   | NO   |     | NULL    |                |
| nouveau         | tinyint(1)   | NO   |     | NULL    |                |
| hors_eff        | tinyint(1)   | NO   |     | NULL    |                |
| situation       | int(11)      | NO   |     | NULL    |                |
| pmal_porte      | tinyint(1)   | NO   |     | NULL    |                |
| pmal_tire       | tinyint(1)   | NO   |     | NULL    |                |
| heb_hosp        | tinyint(1)   | NO   |     | NULL    |                |
| heb_pref        | int(11)      | NO   |     | NULL    |                |
| heb_part        | varchar(50)  | YES  |     | NULL    |                |
| heb_single      | tinyint(1)   | NO   |     | NULL    |                |
| heb_perso       | varchar(25)  | YES  |     | NULL    |                |
| pref_chambre    | int(11)      | NO   |     | NULL    |                |
| garde_nuit      | tinyint(1)   | NO   |     | NULL    |                |
| piscine         | tinyint(1)   | NO   |     | NULL    |                |
| animation       | tinyint(1)   | NO   |     | NULL    |                |
| instrument      | varchar(25)  | YES  |     | NULL    |                |
| tenue           | tinyint(1)   | NO   |     | NULL    |                |
| referent_id     | int(11)      | YES  | MUL | NULL    |                |
| hebergement_id  | int(11)      | YES  | MUL | NULL    |                |
| groupe_id       | int(11)      | YES  | MUL | NULL    |                |
| resp_pele_id    | int(11)      | YES  | MUL | NULL    |                |
| resp_trans_id   | int(11)      | YES  | MUL | NULL    |                |
| num_trans_id    | int(11)      | YES  | MUL | NULL    |                |
| siege_type_id   | int(11)      | YES  | MUL | NULL    |                |
| heb_chambre     | varchar(3)   | YES  |     | NULL    |                |
| grp_chambre     | varchar(10)  | YES  |     | NULL    |                |
| siege_num       | varchar(3)   | YES  |     | NULL    |                |

### hnde_pelerinage
description de la table :

Liste des pèlerinages

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| cle             | varchar(5)   | NO   |     | NULL    |                |
| libelle         | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(15)  | NO   |     | NULL    |                |
| debut           | datetime     | NO   |     | NULL    |                |
| fin             | datetime     | NO   |     | NULL    |                |
| en_cours        | tinyint(1)   | NO   |     | NULL    |                |
| theme           | varchar(255) | NO   |     | NULL    |                |

###  hnde_personne
description de la table :

Liste des membres de l'Hospitalité

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| liste           | varchar(5)   | YES  |     | NULL    |                |
| eglise          | varchar(6)   | YES  |     | NULL    |                |
| civilite        | varchar(10)  | YES  |     | NULL    |                |
| nom             | varchar(50)  | YES  |     | NULL    |                |
| nom_naiss       | varchar(50)  | YES  |     | NULL    |                |
| prenom          | varchar(50)  | YES  |     | NULL    |                |
| genre           | int(11)      | NO   |     | NULL    |                |
| verif           | tinyint(1)   | NO   |     | NULL    |                |
| bulletin        | varchar(5)   | YES  |     | NULL    |                |
| id_reg          | int(11)      | YES  |     | NULL    |                |
| dest_reg        | varchar(50)  | YES  |     | NULL    |                |
| remise          | varchar(50)  | YES  |     | NULL    |                |
| comp_loc        | varchar(50)  | YES  |     | NULL    |                |
| num_voie        | varchar(10)  | YES  |     | NULL    |                |
| type_voie       | varchar(20)  | YES  |     | NULL    |                |
| nom_voie        | varchar(50)  | YES  |     | NULL    |                |
| comp_voie       | varchar(50)  | YES  |     | NULL    |                |
| insee           | varchar(5)   | YES  |     | NULL    |                |
| c_postal        | varchar(10)  | YES  |     | NULL    |                |
| commune         | varchar(50)  | YES  |     | NULL    |                |
| pays            | varchar(50)  | YES  |     | NULL    |                |
| telephone       | varchar(20)  | YES  |     | NULL    |                |
| mobile          | varchar(10)  | YES  |     | NULL    |                |
| lr_courriel     | tinyint(1)   | NO   |     | NULL    |                |
| courriel        | varchar(255) | YES  |     | NULL    |                |
| date_naiss      | datetime     | YES  |     | NULL    |                |
| decede          | tinyint(1)   | NO   |     | NULL    |                |
| date_deces      | datetime     | YES  |     | NULL    |                |
| conseil         | varchar(50)  | YES  |     | NULL    |                |
| eng_hosp        | int(11)      | NO   |     | NULL    |                |
| eng_egl         | int(11)      | NO   |     | NULL    |                |
| p_pele          | int(11)      | NO   |     | NULL    |                |
| nb_pele         | int(11)      | NO   |     | NULL    |                |
| d_pele          | int(11)      | NO   |     | NULL    |                |
| dp_resp         | varchar(50)  | YES  |     | NULL    |                |
| medical         | int(11)      | NO   |     | NULL    |                |
| medical_autre   | varchar(50)  | YES  |     | NULL    |                |
| secteur         | varchar(50)  | YES  |     | NULL    |                |
| paroisse        | varchar(50)  | YES  |     | NULL    |                |
| diocese         | varchar(50)  | YES  |     | NULL    |                |
| is_referent     | tinyint(1)   | NO   |     | NULL    |                |

### hnde_tab_chambre
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| valeur          | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |


### hnde_tab_entite
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| valeur          | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |

### hnde_tab_groupe
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| valeur          | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |
| resp_f          | varchar(30)  | NO   |     | NULL    |                |
| resp_h          | varchar(30)  | NO   |     | NULL    |                |


### hnde_tab_hebergement
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| valeur          | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |

### hnde_tab_medical
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| valeur          | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |

### hnde_tab_resp
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| valeur          | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |

### hnde_tab_siege
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| valeur          | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |

### hnde_tab_situation
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| valeur          | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |

### hnde_tab_statins
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| valeur          | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |

### hnde_tab_transp
description de la table :

Table de parametrage

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| nom             | varchar(50)  | NO   |     | NULL    |                |
| abrege          | varchar(10)  | NO   |     | NULL    |                |
| compagnie       | varchar(255) | NO   |     | NULL    |                |
| capacite        | int(11)      | NO   |     | NULL    |                |
| immatriculation | varchar(9)   | YES  |     | NULL    |                |
| informations    | longtext     | YES  |     | NULL    |                |
| type            | varchar(5)   | NO   |     | NULL    |                |

### hnde_user
description de la table :

Table des utilisateurs

| Field           | Type         | Null | Key | Default | Extra          |
| :-------------- | :----------- | :--: | :-- | :------ | :------------- |
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| email           | varchar(180) | NO   | UNI | NULL    |                |
| roles           | longtext     | NO   |     | NULL    |                |
| password        | varchar(255) | NO   |     | NULL    |                |
| first_name      | varchar(40)  | NO   |     | NULL    |                |
| last_name       | varchar(40)  | NO   |     | NULL    |                |
| reset_token     | varchar(255) | YES  |     | NULL    |                |
| is_enable       | tinyint(1)   | NO   |     | NULL    |                |
