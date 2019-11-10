/*
Fichier : Creation_GroupeA.sql
Auteurs : 
Thomas Besson 21701968
Huro Mirault
Nom du groupe : A
*/

DROP DATABASE IF EXISTS PROJETBDD;
CREATE DATABASE PROJETBDD;
USE PROJETBDD;

/*
Onn supprime les table si elles existe déjà dans la base de donne projetbdd
*/

DROP TABLE IF EXISTS EVENNEMENT;
DROP TABLE IF EXISTS PERSONNE;
DROP TABLE IF EXISTS THEME;
DROP TABLE IF EXISTS NOTE;
DROP TABLE IF EXISTS INSCRIT;
DROP TABLE  IF EXISTS LOGERROR;


/*
creation de la table evennement
*/

CREATE TABLE EVENNEMENT(
    ID_E int(5) NOT NULL AUTO_INCREMENT,
    localisation varchar(50) not null,
    date_e DATE not null,
    descriptif varchar(100),
    max numeric (65,0),
    nbr_participant numeric(65,0),
    id_c int(5) not null,
    nom_t varchar(10) not null,
    constraint pk_ide_e primary key (ID_E),
    constraint fk_id_c foreign key (id_c) references personne(id_p)
);


/*
creation de la table personne
*/

create table PERSONNE(
    id_p int(5) NOT NULL AUTO_INCREMENT,
    pseudo varchar(20) not null,
    pass_word varchar(8) not null,
    domaine varchar(20) not null,
    id_a int(5),
    constraint pk_id_p primary key (id_p),
    constraint fk_admni foreign key (id_a) references personne(id_p)

);

/*
creation de la table them
*/

create table theme(
    nom varchar(10) not null primary key,
    id_a int(5),
    constraint fk_id_a foreign key (id_a) references personne(id_p)
);

/*
creation de la table note
*/

create table note(
    id_v int(5) not null,
    id_e int(5) not null,
    note numeric(2,0) not null,
    primary key (id_v, id_e), 
    constraint fk_id_v foreign key (id_v) references personne(id_p),
    constraint fk_id_e foreign key (id_e) references EVENNEMENT(id_e)
);


/*
creation de la table inscrit
*/

create table inscrit(
    id_v int(5) not null,
    id_e int(5) not null,
    primary key (id_v,id_e),
    constraint fk_id_v foreign key (id_v) references personne(id_p),
    constraint fk_id_e foreign key (id_e) references EVENNEMENT(id_e)
);

	
CREATE TABLE LOGERROR  (
  ID INT(11) AUTO_INCREMENT,
  MESSAGE VARCHAR(255) DEFAULT NULL,
  THETIME TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT PK_LOGERROR PRIMARY KEY (ID)
);	
	

/*
definition de triggers
*/


DROP TRIGGER IF EXISTS domaine
DELIMITER $$
CREATE TRIGGER domaine
BEFORE INSERT on personne
FOR EACH ROW BEGIN
IF NEW.domaine<>"visiteur" AND NEW.domaine<>"administrateur" AND NEW.domaine<>"contributeur" THEN
    INSERT INTO LOGERROR(MESSAGE) VALUES (CONCAT("ATTENTION, LE DOMAINE DOIT EXISTER"));
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LE DOMAINE DOIT EXISTER';
END IF; 
END $$
DELIMITER ;


DROP TRIGGER IF EXISTS noter
DELIMITER $$
CREATE TRIGGER note
BEFORE INSERT ON note
FOR EACH ROW BEGIN
IF (select date_e from evennement e where (new.id_e=e.id_e)) >= (select now()) THEN
    INSERT INTO LOGERROR(MESSAGE) VALUES (CONCAT("ATTENTION, L EVENNEMENT N EST PAS FINI"));
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EVENNEMENT PAS FINI';
END IF; 
END $$
DELIMITER ;

/*
insertion de données dans les tables
*/

insert into personne(pseudo, pass_word, domaine) values ("tomabsn", "besson99", "visiteur");
insert into personne(pseudo, pass_word,domaine) values ("john_34", "1234","visiteur");
insert into personne(pseudo, pass_word,domaine) values ("charlotte", "9872541", "contributeur");
insert into personne(pseudo, pass_word,domaine) values ("lulu", "lucillenbk", "administrateur");

insert into theme values ("noel", 4);
insert into theme values ("halloween", 4);


insert into evennement(localisation, date_e,descriptif, max, nbr_participant, id_c, nom_t) values("Nimes", '2019-12-24', "fete de noel", 100, 0, 3,"noel");
insert into evennement(localisation, date_e,descriptif,max,nbr_participant,id_c,nom_t) values ("Montpellier", '2019-10-2', "fin de halloween", 1000, 0, 3,"alloween");

insert into inscrit values(1,1);

insert into note values (2,2, 12);





