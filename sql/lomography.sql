drop database if exists lomography;
create database lomography;
use lomography;

create table produit(
    idproduit int not null auto_increment,
    img varchar(50),
    nom varchar(50),
    quantite int,
    prix float(5,2),
    primary key (idproduit)
);

create table pellicule(
    idproduit int not null,
    typeFilm varchar(50),
    developpement varchar(50),
    sensibilite varchar(50),
    format int,
    primary key (idproduit),
    foreign key (idproduit) references produit(idproduit)
);

create table appareil(
    idproduit int not null,
    formatPellicule int(10),
    nbPoses int(10),
    focale int(10),
    alimentation varchar(50),
    dimension varchar(50),
    primary key(idproduit),
    foreign key (idproduit) references produit(idproduit)
);

create table objectif(
    idproduit int not null,
    poids float(10),
    diametreMaxAndLongueur float(10),
    diametreFiltre float(10),
    moteurAutoFocus varchar(50),
    agrandissement varchar(50),
    primary key (idproduit),
    foreign key (idproduit) references produit(idproduit)
);

create table media(
    idmedia int not null auto_increment,
    description varchar(50),
    url varchar(50),
    idproduit int,
    primary key (idmedia),
    foreign key (idproduit) references produit (idproduit)
);

create table user(
    iduser int not null auto_increment,
    nom varchar(50),
    prenom varchar(50),
    adresse varchar(50),
    email varchar(50),
    mdp varchar(50),
    droit enum ("admin", "user"),
    primary key (iduser)
);

create table livraison(
    idlivraison int not null auto_increment,
    dateExpedition date,
    datePrevu date,
    serviceLivraison enum("DPD","Chronopost","Mondial Relay"),
    adresse varchar(50),
    typeLivraison enum("Point relais", "A domicile"),
    primary key (idlivraison)
);

-- create table pointRelais(
--     idlivraison int not null,
--     nom varchar(50),
--     horaire varchar(50),
--     primary key (idlivraison),
--     foreign key (idlivraison) references livraison(idlivraison)
-- );

-- create table adressePerso(
--     idlivraison int not null,
--     primary key (idlivraison),
--     foreign key (idlivraison) references livraison(idlivraison)
-- );

--Table créer pour faire la transition entre la table produit et panier
create table contenir(
    qte int,
    idproduit int,
    idpanier int,
    primary key (idproduit, idpanier)
);
--FIN

--Table créer pour faire la transition entre panier livraison et user
create table choisir(
    idlivraison int,
    iduser int,
    idpanier int,
    primary key (idlivraison, iduser, idpanier)
);
--FIN

create table panier(
    idpanier int not null auto_increment,
    prix float(11.2) default 0, 
    primary key (idpanier)
);
-----------------------------------------------Procédures stockés---------------------------------------------------------------
--Procédure stocker pour insérer un appareil
delimiter $
create procedure insertAppareil (IN p_img varchar(50), IN p_nom varchar(50), IN p_quantite int, IN p_prix float(5,2), IN p_formatPellicule int, IN p_nbPoses int, IN p_focale int, IN p_alimentation varchar(50), IN p_dimension varchar(50))
begin 
declare p_idproduit int ;
INSERT INTO produit values (null, p_img, p_nom, p_quantite, p_prix );

SELECT  idproduit into p_idproduit
FROM produit
WHERE img = p_img
AND nom = p_nom
AND quantite = p_quantite
AND prix=p_prix ;
INSERT INTO appareil values (p_idproduit, p_formatPellicule, p_nbPoses, p_focale, p_alimentation, p_dimension);
end $
delimiter ;
--FIN de la procédure

--Procédure stocker pour modifier un appareil
delimiter $
CREATE procedure updateAppareil (IN p_idproduit int, IN p_img varchar(50), IN p_nom varchar(50), IN p_quantite int, IN p_prix float(5, 2), IN p_formatPellicule int, IN p_nbPoses int, IN p_focale int, IN p_alimentation varchar(50), IN p_dimension varchar(50))
begin UPDATE produit

SET idproduit = p_idproduit, img = p_img, nom = p_nom, quantite = p_quantite, prix = p_prix
WHERE idproduit = p_idproduit; UPDATE appareil

SET idproduit = p_idproduit, formatPellicule = p_formatPellicule, nbPoses = p_nbPoses, focale = p_focale, alimentation = p_alimentation, dimension = p_dimension
WHERE idproduit = p_idproduit; end $
delimiter ;
--FIN
--Procédure stocker pour modifier une pellicule
delimiter $
CREATE procedure updatePellicule (IN p_idproduit int, IN p_img varchar(50), IN p_nom varchar(50), IN p_quantite int, IN p_prix float(5, 2), IN p_typeFilm varchar(50), IN p_developpement varchar(50), IN p_sensibilite varchar(50), IN p_format int)
begin UPDATE produit

SET idproduit = p_idproduit, img = p_img, nom = p_nom, quantite = p_quantite, prix = p_prix
WHERE idproduit = p_idproduit; UPDATE pellicule

SET idproduit = p_idproduit, typeFilm = p_typeFilm, developpement = p_developpement, sensibilite = p_sensibilite, format = p_format
WHERE idproduit = p_idproduit; end $
delimiter ;
--FIN
--Procédure stocker pour modifier un objectif
delimiter $
CREATE procedure updateObjectif (IN p_idproduit int, IN p_img varchar(50), IN p_nom varchar(50), IN p_quantite int, IN p_prix float(5, 2), IN p_poids float, IN p_diametreMaxAndLongueur int, IN p_diametreFiltre int, IN p_moteurAutoFocus varchar(50), IN p_agrandissement varchar(50)) begin UPDATE produit

SET idproduit = p_idproduit, img = p_img, nom = p_nom, quantite = p_quantite, prix = p_prix
WHERE idproduit = p_idproduit; UPDATE objectif

SET idproduit = p_idproduit, poids = p_poids, diametreMaxAndLongueur = p_diametreMaxAndLongueur, diametreFiltre = p_diametreFiltre, moteurAutoFocus = p_moteurAutoFocus, agrandissement = p_agrandissement
WHERE idproduit = p_idproduit; end $
delimiter ;
--FIN

--Procédure stocker pour supprimer un appareil
delimiter  $
CREATE procedure deleteAppareil(IN p_idproduit int) begin delete
FROM appareil
WHERE idproduit = p_idproduit; delete
FROM produit
WHERE idproduit = p_idproduit; end $
delimiter ;
--FIN

--Procédure stocker pour afficher l'appareil dans son entiereté
delimiter $
CREATE procedure selectEntireAppareil(IN p_idproduit int) begin
SELECT  p.idproduit
       ,p.img
       ,p.nom
       ,p.quantite
       ,p.prix
       ,a.formatPellicule
       ,a.nbPoses
       ,a.focale
       ,a.alimentation
       ,a.dimension
FROM appareil a, produit p
WHERE a.idproduit = p_idproduit
AND p.idproduit = p_idproduit; end $
delimiter ; 
--FIN

--Procédure stocker pour insérer une pellicule
delimiter $
CREATE procedure insertPellicule (IN p_img varchar(50), IN p_nom varchar(50), IN p_quantite int, IN p_prix float(5, 2), IN p_typeFilm varchar(50), IN p_developpement varchar(50), IN p_sensibilite varchar(50), IN p_format int) begin declare p_idproduit int ;
INSERT INTO produit values (null, p_img, p_nom, p_quantite, p_prix );

SELECT  idproduit into p_idproduit
FROM produit
WHERE img = p_img
AND nom = p_nom
AND quantite = p_quantite
AND prix = p_prix ;
INSERT INTO pellicule values (p_idproduit, p_typeFilm, p_developpement, p_sensibilite, p_format); end $
delimiter ;
--FIN de la procédure

--Procédure stocker pour supprimer une pellicule
delimiter  $
CREATE procedure deletePellicule(IN p_idproduit int) begin delete
FROM pellicule
WHERE idproduit = p_idproduit; delete
FROM produit
WHERE idproduit = p_idproduit; end $
delimiter ;
--FIN

--Procédure stocker pour afficher la pellicule dans son entiereté
delimiter $
CREATE procedure selectEntirePellicule(IN p_idproduit int) begin
SELECT  p.idproduit
       ,p.nom
       ,p.quantite
       ,p.prix
       ,pell.typeFilm
       ,pell.developpement
       ,pell.sensibilite
       ,pell.format
FROM pellicule pell, produit p
WHERE pell.idproduit = p_idproduit
AND p.idproduit = p_idproduit; end $
delimiter ; 
--FIN

--Procédure stocker pour insérer un objectif
delimiter $
CREATE procedure insertObjectif (IN p_img varchar(50), IN p_nom varchar(50), IN p_quantite int, IN p_prix float(5, 2), IN p_poids float, IN p_diametreMaxAndLongueur float, IN p_diametreFiltre float, IN p_moteurAutoFocus varchar(50), IN p_agrandissement varchar(50)) begin declare p_idproduit int ;
INSERT INTO produit values (null, p_img, p_nom, p_quantite, p_prix );

SELECT  idproduit into p_idproduit
FROM produit
WHERE img = p_img
AND nom = p_nom
AND quantite = p_quantite
AND prix=p_prix ;
INSERT INTO objectif values (p_idproduit, p_poids, p_diametreMaxAndLongueur, p_diametreFiltre, p_moteurAutoFocus, p_agrandissement); end $
delimiter ;
--FIN de la procédure

--Procédure stocker pour supprimer un objectif
delimiter  $
CREATE procedure deleteObjectif(IN p_idproduit int) begin delete
FROM objectif
WHERE idproduit = p_idproduit; delete
FROM produit
WHERE idproduit = p_idproduit; end $
delimiter ;
--FIN

--Procédure stocker pour afficher l'objectif dans son entiereté
delimiter $
CREATE procedure selectEntireObjectif(IN p_idproduit int) begin
SELECT  p.idproduit
       ,p.nom
       ,p.quantite
       ,p.prix
       ,o.poids
       ,o.diametreMaxAndLongueur
       ,o.diametreFiltre
       ,o.moteurAutoFocus
       ,o.agrandissement
FROM produit p, objectif o
WHERE o.idproduit = p_idproduit
AND p.idproduit = p_idproduit; end $
delimiter ; 
--FIN
--Procedure stocker d'insertion panier
delimiter $
CREATE procedure insertPanier (IN p_idproduit int(3)) begin declare p_idpanier int(3) ;
INSERT INTO panier value (null, 0);

SELECT  distinct LAST_INSERT_ID() into p_idpanier
FROM panier ;
INSERT INTO contenir values (1, p_idproduit, p_idpanier); end $
delimiter ;
--FIN
--Prcédure stocker d'update contenir (classe liaison entre panier et produit)
delimiter $
CREATE procedure updateContenir (IN p_idproduit int(3), IN p_idpanier int(3), IN choix int) begin declare nb int(3) ; declare p_qte int(3) ;

SELECT  COUNT(*) into nb
FROM contenir
WHERE idproduit = p_idproduit; if nb = 0 THEN
INSERT INTO contenir values (1, p_idproduit, p_idpanier); else

SELECT  qte into p_qte
FROM contenir
WHERE idproduit = p_idproduit
AND idpanier = p_idpanier; if choix <0 THEN if p_qte >= 1 THEN update contenir

SET qte = qte + choix
WHERE idproduit = p_idproduit
AND idpanier = p_idpanier; end if; else update contenir

SET qte = qte + choix
WHERE idproduit = p_idproduit
AND idpanier = p_idpanier; end if; end if; end $
delimiter ;
--FIN
----------------------------------------------Fin procédures stockés--------------------------------------------------------------

----------------------------------------------Insertions--------------------------------------------------------------------------
-- Appareils
call insertAppareil ('images/appareil/actionsampler.jpg','ActionSampler', 20, 29.99, 35, 36, 35, 'CR123A', '15*10*3');

call insertAppareil ('images/appareil/dianaBaby.jpg','Diana Baby + Objectif 12mm', 20, 34.90, 110, 12, 35, 'CR23V', '10*9*3');

call insertAppareil ('images/appareil/fisheyejpg.jpg','Fisheye', 10, 59.00, 35, 36, 35, 'AAA*2', '15*10*3');

call insertAppareil ('images/appareil/horizon.jpg','Horizon', 30, 299.00, 35, 21, 29, 'AA*2', '16*12*5');

call insertAppareil ('images/appareil/jetable.jpg','Appareil jetable rechargeable', 50, 29.00, 35, 39, 35, 'AA*2', '12*7*5');

call insertAppareil ('images/appareil/konstruktor.jpg','Konstruktor', 43, 39.00, 35, 35, 35, 'A*2', '16*11*5');

call insertAppareil ('images/appareil/lc-a.jpg','Lomo LC-A+', 22, 299.00, 35, 36, 35, 'Sans pile', '16*12*4');

call insertAppareil ('images/appareil/lc-wide.jpg','Lomo LC-Wide', 34, 399.00, 35, 36, 35, 'Sans pile', '16*12*4');

call insertAppareil ('images/appareil/lubitel.jpg','Lubitel 166B', 12, 399.00, 120, 12, 52, 'Sans pile', '20*10*10');

call insertAppareil ('images/appareil/lc-120.jpg','Lomo LC-A 120', 9, 449.00, 120, 58, 16, 'Sans pile', '18*13*5');

call insertAppareil ('images/appareil/sprocket.jpg','Sprocket Rocket', 17, 79.00, 35, 21, 32, 'Sans pile', '20*7*4');

-- Pellicules

call insertPellicule ('images/pellicule/berlinkino35mm.jpg','Berlin Kino 400', 50, 9.90,'N&B', 'C-41', '400', 35);

call insertPellicule ('images/pellicule/packcolornegative32mm.jpg','Pack color negative 800', 43, 35.90,'Couleur', 'C-41', '800', 35);

call insertPellicule ('images/pellicule/packcolornegative120.jpg','Pack color negative 100', 23, 46.50,'Couleur', 'C-41', '100', 120);

call insertPellicule ('images/pellicule/packduet35mm.jpg','Pack duet 200', 18, 24.99,'Couleur', 'E-56', '200', 35);

call insertPellicule ('images/pellicule/packladygrey120.jpg','Pack Lady Grey 400', 28, 46.50,'Couleur', 'Cafénol', '400', 120);

call insertPellicule ('images/pellicule/packquartet35mm.jpg','Pack Quartet 200', 5, 53.24,'Mixte', 'C-41', '200', 35);

call insertPellicule ('images/pellicule/packredscale35.jpg 200','Pack Redscale ', 8, 36.00,'Couleur', 'C-41', '50-200', 35);

call insertPellicule ('images/pellicule/packredscale120.jpg','Pack Quartet 200', 2, 63.24,'Couleur', 'C-41', '50-200', 120);

call insertPellicule ('images/pellicule/metropolis120.jpg','Metropolis 400', 14, 11.00,'N&B', 'Cafénol', '50-400', 120);

call insertPellicule ('images/pellicule/metropolis120.jpg','Metropolis 400', 14, 11.00,'N&B', 'Cafénol', '50-400', 120);

-- Objectifs

call insertObjectif ('images/objectif/photoObjectif1.jpg','Pitzval 55 Mark', 4, 299.99, 0.500, 80, 80, 'Manuel', '82mm');

INSERT INTO user values (null, "Jouvet", "Erwann", "1 rue de Gentilly", "erwann.j@gmail.com", "erwann", "user"), 
                        (null, "Rencontre", "Hermann", "1 rue d'Ivry", "hermann.r@gmail.com", "hermann", "admin");

-- insert into livraison values
--     (1, "", "", "", "", ""), (2, "", "", "", "", "");

-- insert into panier values
--     (1, "0"), (2, "0");
-- insert into choisir values
--     (1, 1, 1);
-- call updateAppareil (1, "images/photoAppareil.jpg", "NOKIA-35", 55, 445.99, 155, 145, 135, "USB-C", "15x40x50");
-- call updatePellicule(3, "images/photoAppareil2.jpg", "test", "test", "test", "test", "test", "test", "test");
-----------------------------------------------Fin insertions---------------------------------------------------------------------

-----------------------------------------------Triggers---------------------------------------------------------------------
--TRIGGER POUR INSERER LE PRIX DANS LE PANIER QUAND L'UTILISATEUR ACHETE UN PRODUIT AVEC UNE CERTAINE QUANTITE
delimiter $
CREATE trigger insertContenir after insert
ON contenir for each row begin declare p_prix float;

SELECT  prix into p_prix
FROM produit
WHERE idproduit = new.idproduit; update panier

SET prix = prix + p_prix * new.qte
WHERE idpanier = new.idpanier; end $
delimiter ;
--FIN DU TRIGGER

--TRIGGER POUR MODIFIER LE PRIX QUAND L'UTILISATEUR MODIFIE LA QUANTITE D'UN PRODUIT DANS SON PANIER
delimiter $
CREATE trigger updateContenir after update
ON contenir for each row begin declare p_prix float;

SELECT  prix into p_prix
FROM produit
WHERE idproduit = new.idproduit; update panier

SET prix = prix - p_prix * old.qte
WHERE idpanier = new.idpanier; update panier

SET prix = prix + p_prix * new.qte
WHERE idpanier = new.idpanier; end $
delimiter ;
--FIN DU TRIGGER

-- TEST LUNDI DE LIER L'UTILISATEUR AU PANIER MAIS FAIL--
-- -- TRIGGER QUI CREER UNE TABLE CHOISIR QUAND ON CREER UN UTILISATEUR
-- delimiter $
-- create trigger insertUser after insert on user
-- for each row
-- begin
--     declare c_iduser, c_idpanier, c_idlivraison int;
--     select iduser into c_iduser from user where iduser = new.iduser;
--     insert into panier values (null, "0");
--     select idpanier into c_idpanier from panier where idpanier = new.idpanier;
--     insert into livraison values (null, "", "", "", ":adresse", "");
--     select idlivraison into c_idlivraison from livraison where idlivraison = new.idlivraison;
--     insert into choisir values (":c_iduser",":c_idpanier",":c_iduser");
-- end $
-- delimiter ;
-- --FIN DU TRIGGER

-- delimiter $
-- create trigger insertUser1 after insert on user
-- for each row
-- begin
--     insert into livraison values (null, "", "", "", ":adresse", "");
-- end
-- delimiter;

-- delimiter $
-- create trigger insertLivraison after insert on livraison
-- for each row
-- begin
--     insert into 
--
-------------------------------------------Fin Triggers---------------------------------------------------------------------

-------------------------------------------Debut vues---------------------------------------------------------
CREATE view viewAppareil AS (
SELECT  p.idproduit
       ,p.img
       ,p.nom
       ,p.quantite
       ,p.prix
       ,a.formatPellicule
       ,a.nbPoses
       ,a.focale
       ,a.alimentation
       ,a.dimension
FROM appareil a, produit p
WHERE a.idproduit = p.idproduit );

CREATE view viewPellicule AS (
SELECT  p.idproduit
       ,p.img
       ,p.nom
       ,p.quantite
       ,p.prix
       ,pell.typeFilm
       ,pell.developpement
       ,pell.sensibilite
       ,pell.format
FROM pellicule pell, produit p
WHERE pell.idproduit = p.idproduit );

CREATE view viewObjectif AS (
SELECT  p.idproduit
       ,p.img
       ,p.nom
       ,p.quantite
       ,p.prix
       ,o.poids
       ,o.diametreMaxAndLongueur
       ,o.diametreFiltre
       ,o.moteurAutoFocus
       ,o.agrandissement
FROM objectif o, produit p
WHERE o.idproduit = p.idproduit );

CREATE view viewSumPanier as(
SELECT  SUM(c.idproduit)
FROM contenir c, panier p
WHERE c.idpanier=p.idpanier );

CREATE view vuePanier as(
SELECT  p.nom
       ,p.idproduit
       ,p.prix
       ,c.qte
       ,pn.prix AS total
FROM contenir c, panier pn, produit p
WHERE c.idpanier=pn.idpanier
AND p.idproduit = c.idproduit );
-------------------------------------Fin vues---------------------------------------------------------