-- HNDE Requêtes

pref_hotel: (SELECT hnde_tab_hebergement.valeur FROM hnde_tab_hebergement WHERE hnde_tab_hebergement.id = hnde_inscription.heb_pref)
ref_nom : SELECT hnde_hnde_personne.nom FROM hnde_personne LEFT JOIN hnde_inscription ON hnde_hnde_personne.id = hnde_inscription.referent_id_id;

SELECT hnde_personne.id, hnde_personne.civilite, hnde_personne.nom, hnde_personne.nomNaiss, hnde_personne.prenom, hnde_personne.verif, hnde_personne.remise, hnde_personne.compLoc, hnde_personne.numVoie, hnde_personne.typeVoie, hnde_personne.nomVoie, hnde_personne.compVoie, hnde_personne.cPostal, hnde_personne.bDist, hnde_personne.pays, hnde_personne.telephone, hnde_personne.mobile, hnde_personne.courriel, hnde_personne.dateNaiss, hnde_personne.accueil, hnde_personne.engagement, hnde_personne.pPele, hnde_personne.nbPele, hnde_personne.dPele FROM hnde_personne ORDER BY hnde_personne.id;

SELECT hnde_personne.id, hnde_personne.nom, hnde_personne.nom_naiss, hnde_personne.prenom, hnde_personne.eng_hosp, hnde_personne.eng_egl FROM hnde_personne WHERE (hnde_personne.eng_hosp IS NOT NULL OR hnde_personne.eng_egl IS NOT NULL) ORDER BY hnde_personne.nom, hnde_personne.prenom;

SELECT hnde_personne.id, hnde_personne.nom, hnde_personne.prenom, (SELECT p_param.valeur FROM p_param where p_param.domaine = 'MED' AND p_param.cle = hnde_personne.medical) as medicalx, hnde_personne.medicalAutre FROM personne WHERE hnde_personne.medical >= 1 ORDER BY hnde_personne.nom, hnde_personne.prenom;

-- Tableau affectations

SELECT hnde_inscription.id, concat(hnde_personne.nom, ' ', hnde_personne.prenom) as hospitalier, (SELECT p_param.valeur FROM p_param WHERE p_param.domaine = 'HEB' AND p_param.cle = hnde_inscription.heb_pref) as heb FROM personne LEFT JOIN p_insc ON hnde_personne.id = hnde_inscription.hosp_id WHERE (hnde_inscription.type = 'HO' OR hnde_inscription.type = 'HI') AND (hnde_inscription.statut <> 'S9') AND (hnde_inscription.hors_eff = FALSE) ORDER BY hospitalier

-- Inscriptions

SELECT pelerinage.pele_id, pelerinage.insc_saisie, hospitalite.hosp_HBM AS HBM, pelerinage.pele_voyage, pelerinage.pele_voyage_aller, pelerinage.pele_voyage_retour, CONCAT(hospitalite.hosp_nom, ' ', hospitalite.hosp_prenom) AS hospitalier, hospitalite.hosp_naissance, hospitalite.hosp_nbpele, hospitalite.hosp_dpele FROM pelerinage LEFT JOIN hospitalite ON pelerinage.hosp_id = hospitalite.hosp_id WHERE pelerinage.pele_id<5000 AND (hospitalite.hosp_HBM = 1 OR hospitalite.hosp_HBM = 2) AND pelerinage.insc_statut<9 ORDER BY hospitalier;

-- Gardes de nuit

SELECT pelerinage.pele_id, hospitalite.hosp_HBM AS HBM, CONCAT(hospitalite.hosp_nom, ' ', hospitalite.hosp_prenom) AS hospitalier, pelerinage.pele_srvl_gnuit_jour FROM pelerinage LEFT JOIN hospitalite ON pelerinage.hosp_id = hospitalite.hosp_id WHERE pelerinage.pele_srvl_gnuit ORDER BY pelerinage.pele_srvl_gnuit_jour;

-- 
SELECT pelerinage.pele_id, hospitalite.hosp_HBM, CONCAT(hospitalite.hosp_nom, ' ', hospitalite.hosp_prenom) AS hospitalier, pelerinage.insc_logement, pelerinage.insc_log_single, pelerinage.insc_hotel, hebergement.hbrg_lieu, pelerinage.insc_log_compl FROM pelerinage LEFT JOIN hospitalite ON pelerinage.hosp_id = hospitalite.hosp_id LEFT JOIN hebergement ON pelerinage.pele_hotel = hebergement.hbrg_id WHERE pelerinage.pele_id<5000 AND pelerinage.insc_statut<9 

--
SELECT Pelerinage.pele_id, IIf([insc_saisie],"","*") AS saisie, Hospitalite.hosp_HBM AS HBM, IIf([pele_voyage],IIf([pele_voyage_aller],IIf([pele_voyage_retour],"O","Oa"),IIf([pele_voyage_retour],"Or","?????")),"") AS Train, [hosp_nom] & " " & [hosp_prenom] AS Hospitalier, IIf(IsNull([hosp_naissance]),0,(Year(#8/24/2017#-[hosp_naissance])-1900)) AS Age, IIf([pele_nouveau],IIf(IsNull([hosp_naissance]),"N",IIf([Age]<26,"NJ","N")),IIf(IsNull([hosp_naissance]),"",IIf([Age]<26,"J",""))) AS Situation, Hospitalite.hosp_nbpele AS Nb, Hospitalite.hosp_dpele AS DPele, IIf(IsNull([pele_responsable]),"",[pele_responsable] & IIf([hosp_medical]=1," - Médecin",IIf([hosp_medical]=2," - Infirmier(ère)",IIf([hosp_medical]=3," - Aide Soignant(e)",IIf([hosp_medical]=4," - Kinésithérapeute",IIf([hosp_medical]=5," - Pharmacien(ne)",IIf([hosp_medical]=9," - " & [hosp_medical_autre],""))))))) AS Responsabilité, IIf([insc_logement]=1,"(*) " & [insc_hotel],IIf(Len([insc_hotel])>0,"==> " & [insc_hotel],"")) AS heberg, IIf([insc_log_single],"S","") AS [single], Pelerinage.insc_log_avec, Pelerinage.insc_log_compl, IIf([insc_personne]="I","",[insc_personne]) AS personne, IIf([insc_fauteuil],"N","") AS fauteuil, IIf([insc_voiture],"N","") AS voiture, IIf([insc_gnuit],"O","") AS gnuit, IIf([insc_piscine],"O","") AS piscine, IIf([insc_animation],"O","") AS anim, Pelerinage.insc_instrument
FROM (Hospitalite INNER JOIN Pelerinage ON Hospitalite.hosp_id = Pelerinage.hosp_id) LEFT JOIN Hebergement ON Pelerinage.pele_hotel = Hebergement.hbrg_id
WHERE (((Pelerinage.pele_id)<5000) AND ((Hospitalite.hosp_HBM)=1 Or (Hospitalite.hosp_HBM)=2) AND ((Pelerinage.insc_statut)<9))
ORDER BY Hospitalite.hosp_nom, Hospitalite.hosp_prenom;

-- Services
UPDATE `pelerinage` SET `pele_service_abr` = NULL;
UPDATE `pelerinage` SET `pele_service_abr` = 'S' WHERE `pelerinage`.`pele_service` = 'Service à la salle à manger';
UPDATE `pelerinage` SET `pele_service_abr` = 'C' WHERE `pelerinage`.`pele_service` = 'Service en chambre';
UPDATE `pelerinage` SET `pele_service_abr` = 'M' WHERE `pelerinage`.`pele_service` = 'Service marcheurs';

UPDATE `pelerinage` SET `pele_medicaments` = 0;
UPDATE `pelerinage` SET `pele_medicaments` = '-1' WHERE `pelerinage`.`medicament` LIKE 'Distri%';

-- Mise à jour post pèlerinage
SELECT hnde_personne.nom, hnde_personne.prenom, hnde_personne.pPele, hnde_personne.dPele, hnde_personne.nbPele, hnde_inscription.titre FROM personne INNER JOIN p_insc ON hnde_personne.id = hnde_inscription.hosp_id WHERE hnde_inscription.statut < 8 AND hnde_inscription.hors_eff = 0 ORDER BY hnde_personne.nom, hnde_personne.prenom;

UPDATE personne INNER JOIN p_insc ON hnde_personne.id = hnde_inscription.hosp_id SET hnde_personne.nbPele=hnde_personne.nbPele+1, hnde_personne.dPele=2018 WHERE hnde_inscription.statut < 8 AND hnde_inscription.hors_eff = 0;
UPDATE personne INNER JOIN p_insc ON hnde_personne.id = hnde_inscription.hosp_id SET hnde_personne.nbPele=1 WHERE hnde_inscription.statut < 8 AND hnde_inscription.hors_eff = 0 AND hnde_inscription.titre = 'LY';

-- Extrait pour envoi postal du bulletin
select CONCAT(hnde_personne.civilite, ' ', hnde_personne.nom, ' ', hnde_personne.prenom) AS lgn1, hnde_personne.remise AS lgn2, hnde_personne.compLoc AS lgn3, CONCAT(hnde_personne.numVoie, ' ', hnde_personne.typeVoie, ' ', hnde_personne.nomVoie) AS lgn4, hnde_personne.compVoie AS lgn5, CONCAT(hnde_personne.cPostal, ' ', hnde_personne.commune) AS lgn6, hnde_personne.pays AS lgn7 FROM personne WHERE bulletin ="POSTE";

-- Rq Analyse inscriptions
SELECT DISTINCTROW IIf([type]="PM","Non",IIf([g]="H","Brancardier","Hospitalière")) AS hosp, IIf([type]="PM",IIf([g]="H","Homme","Femme"),"Non") AS pmh, session.id, session.statut, hnde_personne.nom, hnde_personne.prenom, Left([cPostal],2) AS dep, IIf(IsNull([dateNaiss]),0,(Year(#7/15/2018#-[dateNaiss])-1900)) AS age, IIf([age]=0,"0: nc",IIf([age]<=15,"1: 15 ans et -",IIf([age]<=25,"2: 16 à 25 ans",IIf([age]<=35,"3: 26 à 35 ans",IIf([age]<=45,"4: 36 à 45 ans",IIf([age]<=55,"5: 46 à 55 ans",IIf([age]<=65,"6: 56 à 65 ans",IIf([age]<=75,"7: 66 à 75 ans","8: 76 ans et +")))))))) AS trn, IIf([aller],"Car","Non") AS voy, IIf([nouveau],"oui","non") AS nouv, IIf([nouveau],IIf(IsNull([dateNaiss]),"N",IIf([Age]<26,"NJ","N")),IIf(IsNull([dateNaiss]),"",IIf([Age]<26,"J",""))) AS sit, IIf([civilite]="M.","H",IIf([civilite]="Père","H","F")) AS g, session.hors_eff FROM [session] INNER JOIN personne ON session.hosp_id = hnde_personne.id ORDER BY session.id;

-- Rq_préparation_tableau_hospitaliers

SELECT DISTINCTROW hnde_inscription.id, IIf([hnde_personne.civilite]="M.","B",IIf([hnde_personne.civilite]="Père","B","H")) AS hbm, IIf(IsNull([hnde_personne.dateNaiss]),0,(Year(#7/15/2018#-[hnde_personne.dateNaiss])-1900)) AS age, hnde_personne.nbPele AS nb, hnde_personne.dPele AS dp, IIf([hnde_inscription.nouveau],IIf(IsNull([hnde_personne.dateNaiss]),"N",IIf([age]<26,"NJ","N")),IIf(IsNull([hnde_personne.dateNaiss]),"",IIf([age]<26,"J",""))) AS sit, IIf([hnde_personne.engagement],"E " & [hnde_personne.engagement],IIf([hnde_personne.accueil],"A " & [hnde_personne.accueil],"")) AS Statut, IIf([hnde_personne.engagement],"",IIf([hnde_personne.accueil],IIf((2016-[hnde_personne.accueil]>=2),IIf(([hnde_personne.nbPele]>=4),"E",""),""),IIf(([hnde_personne.nbPele]>=2),"A",IIf(([hnde_personne.nbPele]=1),"*","")))) AS propos, [hnde_personne.nom] & " " & [hnde_personne.prenom] AS hospitalier, hnde_inscription.car_num as car, hnde_inscription.car_place as pl, IIf([heb_hosp],[heb_pref],"(*) " & [heb_perso]) AS heberg, IIf([heb_single],"S","") AS [single]
FROM personne INNER JOIN p_insc ON hnde_personne.id = hnde_inscription.hosp_id
WHERE (((hnde_inscription.type)="HO" Or (hnde_inscription.type)="HI") AND ((hnde_inscription.statut)<>"S9") AND ((hnde_inscription.hors_eff)=No))
ORDER BY hnde_personne.nom, hnde_personne.prenom;

IIf([hnde_inscription.heb_hosp],[hnde_inscription.heb_hotel],"(*) " & [hnde_inscription.heb_perso]) AS heberg
pelerinage.pele_responsable_abr,
groupe.grpe_init AS groupe,
pelerinage.pele_service_abr AS service
IIf([p_aff.serv_medicaments],"X","") AS medoc

SELECT hnde_inscription.id, CONCAT([hnde_personne.nom], " ", [hnde_personne.prenom]) AS hospitalier WHERE (((hnde_inscription.type)="HO" Or (hnde_inscription.type)="HI") AND ((hnde_inscription.statut)<>"S9") AND ((hnde_inscription.hors_eff)=No))FROM personne INNER JOIN p_insc ON hnde_personne.id = hnde_inscription.hosp_id ORDER BY hospitalier

SELECT DISTINCTROW pelerinage.pele_id, IIf([hosp_HBM]=1,"H","B") AS HB, IIf(IsNull([hosp_naissance]),0,(Year(#8/24/2017#-[hosp_naissance])-1900)) AS Age, hospitalite.hosp_nbpele AS [Nb Pélé], hospitalite.hosp_dpele AS [D Pélé], IIf([pele_nouveau],IIf(IsNull([hosp_naissance]),"N",IIf([Age]<26,"NJ","N")),IIf(IsNull([hosp_naissance]),"",IIf([Age]<26,"J",""))) AS Situation, IIf([hosp_engag],"E " & [hosp_engag_annee],IIf([hosp_accueil],"A " & [hosp_accueil_annee],"")) AS Statut, IIf([hosp_engag],"",IIf([hosp_accueil],IIf((2008-[hosp_accueil_annee]>=2),IIf(([hosp_nbpele]>=4),"E",""),""),IIf(([hosp_nbpele]>=2),"A",IIf(([hosp_nbpele]=1),"*","")))) AS Propos, [hosp_nom] & " " & [hosp_prenom] AS nomprénom, pelerinage.pele_voiture, pelerinage.pele_place, IIf([insc_logement]=1,"(*) " & [insc_hotel],[hbrg_lieu]) AS heberg, pelerinage.pele_responsable_abr, groupe.grpe_init AS groupe, pelerinage.pele_service_abr AS service, IIf([pele_medicaments],"X","") AS medoc
FROM hospitalite RIGHT JOIN ((pelerinage LEFT JOIN hebergement ON pelerinage.pele_hotel = hebergement.hbrg_id) LEFT JOIN groupe ON pelerinage.pele_groupe = groupe.grpe_id) ON hospitalite.hosp_id = pelerinage.pele_hospid
WHERE (((pelerinage.pele_id)>0 And (pelerinage.pele_id)<5000) AND ((pelerinage.insc_statut)<9) AND ((hospitalite.hosp_HBM)=1 Or (hospitalite.hosp_HBM)=2))
ORDER BY [hosp_nom] & " " & [hosp_prenom];

=VraiFaux([pele_resp];VraiFaux([pele_resp]=6;"Equipe médicale - ";(SELECT tab_resp.valeur FROM tab_resp WHERE hnde_inscription.pele_resp=tab_resp.id));"")

(SELECT tab_resp.valeur FROM tab_resp WHERE hnde_inscription.pele_resp=tab_resp.id)
(SELECT tab_medical.valeur FROM tab_medical WHERE hnde_personne.medical=tab_resp.id)

(SELECT tab_heberg.abrege FROM tab_heberg WHERE tab_heberg.id = hnde_inscription.heb_pref)

-- Mises  à jour après pèlerinage

-- Mise à jour dernier pele
SELECT hnde_inscription.numsdp, hnde_personne.nom, hnde_personne.prenom, hnde_personne.nb_pele FROM hnde_personne RIGHT JOIN hnde_inscription ON hnde_personne.id = hnde_inscription.pelerin_id WHERE hnde_inscription.insc_statut < 8;
UPDATE hnde_personne RIGHT JOIN hnde_inscription ON hnde_personne.id = hnde_inscription.pelerin_id SET hnde_personne.d_pele = 2019 WHERE hnde_inscription.insc_statut < 8;

-- Mise à jour premier pele
SELECT hnde_inscription.numsdp, hnde_personne.nom, hnde_personne.prenom FROM hnde_personne RIGHT JOIN hnde_inscription ON hnde_personne.id = hnde_inscription.pelerin_id WHERE hnde_inscription.insc_statut < 8 AND hnde_inscription.nouveau IS TRUE;
UPDATE hnde_personne RIGHT JOIN hnde_inscription ON hnde_personne.id = hnde_inscription.pelerin_id SET hnde_personne.p_pele = 2019 WHERE hnde_inscription.insc_statut < 8 AND hnde_inscription.nouveau IS TRUE;

-- Mise à jour nombre pele =+ 1 (tous)
SELECT hnde_inscription.numsdp, hnde_personne.nom, hnde_personne.prenom, hnde_personne.nb_pele FROM hnde_personne RIGHT JOIN hnde_inscription ON hnde_personne.id = hnde_inscription.pelerin_id WHERE hnde_inscription.insc_statut < 8;
UPDATE hnde_personne RIGHT JOIN hnde_inscription ON hnde_personne.id = hnde_inscription.pelerin_id SET hnde_personne.nb_pele = hnde_personne.nb_pele + 1 WHERE hnde_inscription.insc_statut < 8;

-- Mise à jour nombre pele = 1 (LY et HEFF)
SELECT hnde_inscription.numsdp, hnde_personne.nom, hnde_personne.prenom, hnde_personne.nb_pele FROM hnde_personne RIGHT JOIN hnde_inscription ON hnde_personne.id = hnde_inscription.pelerin_id WHERE hnde_inscription.insc_statut < 8 AND (hnde_inscription.hors_eff IS TRUE OR hnde_inscription.entite = 4);
UPDATE hnde_personne RIGHT JOIN hnde_inscription ON hnde_personne.id = hnde_inscription.pelerin_id SET hnde_personne.nb_pele = 1 WHERE hnde_inscription.insc_statut < 8 AND (hnde_inscription.hors_eff IS TRUE OR hnde_inscription.entite = 4);
