# HNDE Requêtes

## pref_hotel

```sql (access)
SELECT tab_hebergement.valeur FROM tab_hebergement WHERE tab_hebergement.id = inscription.heb_pref
```

## ref_nom

```sql
SELECT personne.nom FROM personne LEFT JOIN inscription ON personne.id = inscription.referent_id_id;
```

```sql
SELECT personne.id, personne.civilite, personne.nom, personne.nomNaiss, personne.prenom, personne.verif, personne.remise, personne.compLoc, personne.numVoie, personne.typeVoie, personne.nomVoie, personne.compVoie, personne.cPostal, personne.bDist, personne.pays, personne.telephone, personne.mobile, personne.courriel, personne.dateNaiss, personne.accueil, personne.engagement, personne.pPele, personne.nbPele, personne.dPele FROM personne ORDER BY personne.id;
```

```sql
SELECT personne.id, personne.nom, personne.nom_naiss, personne.prenom, personne.eng_hosp, personne.eng_egl FROM personne WHERE (personne.eng_hosp IS NOT NULL OR personne.eng_egl IS NOT NULL) ORDER BY personne.nom, personne.prenom;
```

```sql
SELECT personne.id, personne.nom, personne.prenom, (SELECT p_param.valeur FROM p_param where p_param.domaine = 'MED' AND p_param.cle = personne.medical) as medicalx, personne.medicalAutre FROM personne WHERE personne.medical >= 1 ORDER BY personne.nom, personne.prenom;
```

## Tableau affectations

```sql
SELECT inscription.id, concat(personne.nom, ' ', personne.prenom) as hospitalier, (SELECT p_param.valeur FROM p_param WHERE p_param.domaine = 'HEB' AND p_param.cle = inscription.heb_pref) as heb FROM personne LEFT JOIN p_insc ON personne.id = inscription.hosp_id WHERE (inscription.type = 'HO' OR inscription.type = 'HI') AND (inscription.statut <> 'S9') AND (inscription.hors_eff = FALSE) ORDER BY hospitalier
```

## Inscriptions

```sql
SELECT pelerinage.pele_id, pelerinage.insc_saisie, hospitalite.hosp_HBM AS HBM, pelerinage.pele_voyage, pelerinage.pele_voyage_aller, pelerinage.pele_voyage_retour, CONCAT(hospitalite.hosp_nom, ' ', hospitalite.hosp_prenom) AS hospitalier, hospitalite.hosp_naissance, hospitalite.hosp_nbpele, hospitalite.hosp_dpele FROM pelerinage LEFT JOIN hospitalite ON pelerinage.hosp_id = hospitalite.hosp_id WHERE pelerinage.pele_id<5000 AND (hospitalite.hosp_HBM = 1 OR hospitalite.hosp_HBM = 2) AND pelerinage.insc_statut<9 ORDER BY hospitalier;
```

## Gardes de nuit

```sql
SELECT pelerinage.pele_id, hospitalite.hosp_HBM AS HBM, CONCAT(hospitalite.hosp_nom, ' ', hospitalite.hosp_prenom) AS hospitalier, pelerinage.pele_srvl_gnuit_jour FROM pelerinage LEFT JOIN hospitalite ON pelerinage.hosp_id = hospitalite.hosp_id WHERE pelerinage.pele_srvl_gnuit ORDER BY pelerinage.pele_srvl_gnuit_jour;
```

## 

```sql
SELECT pelerinage.pele_id, hospitalite.hosp_HBM, CONCAT(hospitalite.hosp_nom, ' ', hospitalite.hosp_prenom) AS hospitalier, pelerinage.insc_logement, pelerinage.insc_log_single, pelerinage.insc_hotel, hebergement.hbrg_lieu, pelerinage.insc_log_compl FROM pelerinage LEFT JOIN hospitalite ON pelerinage.hosp_id = hospitalite.hosp_id LEFT JOIN hebergement ON pelerinage.pele_hotel = hebergement.hbrg_id WHERE pelerinage.pele_id<5000 AND pelerinage.insc_statut<9 
```

## Access

```sql (access)
SELECT Pelerinage.pele_id, IIf([insc_saisie],"","*") AS saisie, Hospitalite.hosp_HBM AS HBM, IIf([pele_voyage],IIf([pele_voyage_aller],IIf([pele_voyage_retour],"O","Oa"),IIf([pele_voyage_retour],"Or","?????")),"") AS Train, [hosp_nom] & " " & [hosp_prenom] AS Hospitalier, IIf(IsNull([hosp_naissance]),0,(Year(#8/24/2017#-[hosp_naissance])-1900)) AS Age, IIf([pele_nouveau],IIf(IsNull([hosp_naissance]),"N",IIf([Age]<26,"NJ","N")),IIf(IsNull([hosp_naissance]),"",IIf([Age]<26,"J",""))) AS Situation, Hospitalite.hosp_nbpele AS Nb, Hospitalite.hosp_dpele AS DPele, IIf(IsNull([pele_responsable]),"",[pele_responsable] & IIf([hosp_medical]=1," - Médecin",IIf([hosp_medical]=2," - Infirmier(ère)",IIf([hosp_medical]=3," - Aide Soignant(e)",IIf([hosp_medical]=4," - Kinésithérapeute",IIf([hosp_medical]=5," - Pharmacien(ne)",IIf([hosp_medical]=9," - " & [hosp_medical_autre],""))))))) AS Responsabilité, IIf([insc_logement]=1,"(*) " & [insc_hotel],IIf(Len([insc_hotel])>0,"==> " & [insc_hotel],"")) AS heberg, IIf([insc_log_single],"S","") AS [single], Pelerinage.insc_log_avec, Pelerinage.insc_log_compl, IIf([insc_personne]="I","",[insc_personne]) AS personne, IIf([insc_fauteuil],"N","") AS fauteuil, IIf([insc_voiture],"N","") AS voiture, IIf([insc_gnuit],"O","") AS gnuit, IIf([insc_piscine],"O","") AS piscine, IIf([insc_animation],"O","") AS anim, Pelerinage.insc_instrument
FROM (Hospitalite INNER JOIN Pelerinage ON Hospitalite.hosp_id = Pelerinage.hosp_id) LEFT JOIN Hebergement ON Pelerinage.pele_hotel = Hebergement.hbrg_id
WHERE (((Pelerinage.pele_id)<5000) AND ((Hospitalite.hosp_HBM)=1 Or (Hospitalite.hosp_HBM)=2) AND ((Pelerinage.insc_statut)<9))
ORDER BY Hospitalite.hosp_nom, Hospitalite.hosp_prenom;
```

## Services

```sql
UPDATE `pelerinage` SET `pele_service_abr` = NULL;
UPDATE `pelerinage` SET `pele_service_abr` = 'S' WHERE `pelerinage`.`pele_service` = 'Service à la salle à manger';
UPDATE `pelerinage` SET `pele_service_abr` = 'C' WHERE `pelerinage`.`pele_service` = 'Service en chambre';
UPDATE `pelerinage` SET `pele_service_abr` = 'M' WHERE `pelerinage`.`pele_service` = 'Service marcheurs';

UPDATE `pelerinage` SET `pele_medicaments` = 0;
UPDATE `pelerinage` SET `pele_medicaments` = '-1' WHERE `pelerinage`.`medicament` LIKE 'Distri%';
```

## Mise à jour post pèlerinage

```sql
SELECT personne.nom, personne.prenom, personne.pPele, personne.dPele, personne.nbPele, inscription.titre FROM personne INNER JOIN p_insc ON personne.id = inscription.hosp_id WHERE inscription.statut < 8 AND inscription.hors_eff = 0 ORDER BY personne.nom, personne.prenom;
```

```sql
UPDATE personne INNER JOIN p_insc ON personne.id = inscription.hosp_id SET personne.nbPele=personne.nbPele+1, personne.dPele=2018 WHERE inscription.statut < 8 AND inscription.hors_eff = 0;
```

```sql
UPDATE personne INNER JOIN p_insc ON personne.id = inscription.hosp_id SET personne.nbPele=1 WHERE inscription.statut < 8 AND inscription.hors_eff = 0 AND inscription.titre = 'LY';
```

## Extrait pour envoi postal du bulletin

```sql
select CONCAT(personne.civilite, ' ', personne.nom, ' ', personne.prenom) AS lgn1, personne.remise AS lgn2, personne.compLoc AS lgn3, CONCAT(personne.numVoie, ' ', personne.typeVoie, ' ', personne.nomVoie) AS lgn4, personne.compVoie AS lgn5, CONCAT(personne.cPostal, ' ', personne.commune) AS lgn6, personne.pays AS lgn7 FROM personne WHERE bulletin ="POSTE";
```

## Rq Analyse inscriptions

```sql (access)
SELECT DISTINCTROW IIf([type]="PM","Non",IIf([g]="H","Brancardier","Hospitalière")) AS hosp, IIf([type]="PM",IIf([g]="H","Homme","Femme"),"Non") AS pmh, session.id, session.statut, personne.nom, personne.prenom, Left([cPostal],2) AS dep, IIf(IsNull([dateNaiss]),0,(Year(#7/15/2018#-[dateNaiss])-1900)) AS age, IIf([age]=0,"0: nc",IIf([age]<=15,"1: 15 ans et -",IIf([age]<=25,"2: 16 à 25 ans",IIf([age]<=35,"3: 26 à 35 ans",IIf([age]<=45,"4: 36 à 45 ans",IIf([age]<=55,"5: 46 à 55 ans",IIf([age]<=65,"6: 56 à 65 ans",IIf([age]<=75,"7: 66 à 75 ans","8: 76 ans et +")))))))) AS trn, IIf([aller],"Car","Non") AS voy, IIf([nouveau],"oui","non") AS nouv, IIf([nouveau],IIf(IsNull([dateNaiss]),"N",IIf([Age]<26,"NJ","N")),IIf(IsNull([dateNaiss]),"",IIf([Age]<26,"J",""))) AS sit, IIf([civilite]="M.","H",IIf([civilite]="Père","H","F")) AS g, session.hors_eff FROM [session] INNER JOIN personne ON session.hosp_id = personne.id ORDER BY session.id;
```

## Rq_préparation_tableau_hospitaliers

```sql (access)
SELECT DISTINCTROW inscription.id, IIf([personne.civilite]="M.","B",IIf([personne.civilite]="Père","B","H")) AS hbm, IIf(IsNull([personne.dateNaiss]),0,(Year(#7/15/2018#-[personne.dateNaiss])-1900)) AS age, personne.nbPele AS nb, personne.dPele AS dp, IIf([inscription.nouveau],IIf(IsNull([personne.dateNaiss]),"N",IIf([age]<26,"NJ","N")),IIf(IsNull([personne.dateNaiss]),"",IIf([age]<26,"J",""))) AS sit, IIf([personne.engagement],"E " & [personne.engagement],IIf([personne.accueil],"A " & [personne.accueil],"")) AS Statut, IIf([personne.engagement],"",IIf([personne.accueil],IIf((2016-[personne.accueil]>=2),IIf(([personne.nbPele]>=4),"E",""),""),IIf(([personne.nbPele]>=2),"A",IIf(([personne.nbPele]=1),"*","")))) AS propos, [personne.nom] & " " & [personne.prenom] AS hospitalier, inscription.car_num as car, inscription.car_place as pl, IIf([heb_hosp],[heb_pref],"(*) " & [heb_perso]) AS heberg, IIf([heb_single],"S","") AS [single]
FROM personne INNER JOIN p_insc ON personne.id = inscription.hosp_id
WHERE (((inscription.type)="HO" Or (inscription.type)="HI") AND ((inscription.statut)<>"S9") AND ((inscription.hors_eff)=No))
ORDER BY personne.nom, personne.prenom;
```

```sql (access)
IIf([inscription.heb_hosp],[inscription.heb_hotel],"(*) " & [inscription.heb_perso]) AS heberg
pelerinage.pele_responsable_abr,
groupe.grpe_init AS groupe,
pelerinage.pele_service_abr AS service
IIf([p_aff.serv_medicaments],"X","") AS medoc
```

```sql
SELECT inscription.id, CONCAT([personne.nom], " ", [personne.prenom]) AS hospitalier WHERE (((inscription.type)="HO" Or (inscription.type)="HI") AND ((inscription.statut)<>"S9") AND ((inscription.hors_eff)=No))FROM personne INNER JOIN p_insc ON personne.id = inscription.hosp_id ORDER BY hospitalier
```

```sql (access)
SELECT DISTINCTROW pelerinage.pele_id, IIf([hosp_HBM]=1,"H","B") AS HB, IIf(IsNull([hosp_naissance]),0,(Year(#8/24/2017#-[hosp_naissance])-1900)) AS Age, hospitalite.hosp_nbpele AS [Nb Pélé], hospitalite.hosp_dpele AS [D Pélé], IIf([pele_nouveau],IIf(IsNull([hosp_naissance]),"N",IIf([Age]<26,"NJ","N")),IIf(IsNull([hosp_naissance]),"",IIf([Age]<26,"J",""))) AS Situation, IIf([hosp_engag],"E " & [hosp_engag_annee],IIf([hosp_accueil],"A " & [hosp_accueil_annee],"")) AS Statut, IIf([hosp_engag],"",IIf([hosp_accueil],IIf((2008-[hosp_accueil_annee]>=2),IIf(([hosp_nbpele]>=4),"E",""),""),IIf(([hosp_nbpele]>=2),"A",IIf(([hosp_nbpele]=1),"*","")))) AS Propos, [hosp_nom] & " " & [hosp_prenom] AS nomprénom, pelerinage.pele_voiture, pelerinage.pele_place, IIf([insc_logement]=1,"(*) " & [insc_hotel],[hbrg_lieu]) AS heberg, pelerinage.pele_responsable_abr, groupe.grpe_init AS groupe, pelerinage.pele_service_abr AS service, IIf([pele_medicaments],"X","") AS medoc
FROM hospitalite RIGHT JOIN ((pelerinage LEFT JOIN hebergement ON pelerinage.pele_hotel = hebergement.hbrg_id) LEFT JOIN groupe ON pelerinage.pele_groupe = groupe.grpe_id) ON hospitalite.hosp_id = pelerinage.pele_hospid
WHERE (((pelerinage.pele_id)>0 And (pelerinage.pele_id)<5000) AND ((pelerinage.insc_statut)<9) AND ((hospitalite.hosp_HBM)=1 Or (hospitalite.hosp_HBM)=2))
ORDER BY [hosp_nom] & " " & [hosp_prenom];
```

```sql (access)
=VraiFaux([pele_resp];VraiFaux([pele_resp]=6;"Equipe médicale - ";(SELECT tab_resp.valeur FROM tab_resp WHERE inscription.pele_resp=tab_resp.id));"")
```

```sql (access)
SELECT tab_resp.valeur FROM tab_resp WHERE inscription.pele_resp=tab_resp.id
SELECT tab_medical.valeur FROM tab_medical WHERE personne.medical=tab_resp.id
SELECT tab_heberg.abrege FROM tab_heberg WHERE tab_heberg.id = inscription.heb_pref
```

## Mises  à jour après pèlerinage

### Mise à jour dernier pele

```sql
SELECT inscription.numsdp, personne.nom, personne.prenom, personne.nb_pele FROM personne RIGHT JOIN inscription ON personne.id = inscription.pelerin_id WHERE inscription.insc_statut < 8;
```

```sql
UPDATE personne RIGHT JOIN inscription ON personne.id = inscription.pelerin_id SET personne.d_pele = 2019 WHERE inscription.insc_statut < 8;
```

### Mise à jour premier pele

```sql
SELECT inscription.numsdp, personne.nom, personne.prenom FROM personne RIGHT JOIN inscription ON personne.id = inscription.pelerin_id WHERE inscription.insc_statut < 8 AND inscription.nouveau IS TRUE;
UPDATE personne RIGHT JOIN inscription ON personne.id = inscription.pelerin_id SET personne.p_pele = 2019 WHERE inscription.insc_statut < 8 AND inscription.nouveau IS TRUE;
```

### Mise à jour nombre pele =+ 1 (tous)

```sql
SELECT inscription.numsdp, personne.nom, personne.prenom, personne.nb_pele FROM personne RIGHT JOIN inscription ON personne.id = inscription.pelerin_id WHERE inscription.insc_statut < 8;
UPDATE personne RIGHT JOIN inscription ON personne.id = inscription.pelerin_id SET personne.nb_pele = personne.nb_pele + 1 WHERE inscription.insc_statut < 8;
```

### Mise à jour nombre pele = 1 (LY et HEFF)

```sql
SELECT inscription.numsdp, personne.nom, personne.prenom, personne.nb_pele FROM personne RIGHT JOIN inscription ON personne.id = inscription.pelerin_id WHERE inscription.insc_statut < 8 AND (inscription.hors_eff IS TRUE OR inscription.entite = 4);
```

```sql
UPDATE personne RIGHT JOIN inscription ON personne.id = inscription.pelerin_id SET personne.nb_pele = 1 WHERE inscription.insc_statut < 8 AND (inscription.hors_eff IS TRUE OR inscription.entite = 4);
```
