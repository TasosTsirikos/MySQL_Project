DROP DATABASE if exists travel_agency;
CREATE DATABASE travel_agency;
USE travel_agency;

CREATE TABLE branch(
br_code INT(11), 
br_street VARCHAR(30) DEFAULT 'unknown' NOT NULL,
br_num INT(4) NOT NULL,
br_city VARCHAR(30) DEFAULT 'unknown' NOT NULL,
PRIMARY KEY (br_code)
);

CREATE TABLE phones(
ph_br_code INT(11) NOT NULL,
ph_number CHAR(10) NOT NULL,
PRIMARY KEY (ph_br_code, ph_number),
CONSTRAINT BRPHONE
FOREIGN KEY (ph_br_code) REFERENCES branch(br_code)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE worker(
wrk_AT CHAR(10) NOT NULL,
wrk_name VARCHAR(20) DEFAULT 'unknown' NOT NULL,
wrk_lname VARCHAR(20) DEFAULT 'unknown' NOT NULL,
wrk_salary FLOAT(7,2) NOT NULL,
wrk_br_code INT(11) NOT NULL,
PRIMARY KEY (wrk_AT),
CONSTRAINT BRWORKER
FOREIGN KEY (wrk_br_code) REFERENCES branch(br_code)
ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE admin(
adm_AT CHAR(10) NOT NULL,
adm_type ENUM('LOGISTICS','ADMINISTRATIVE','ACCOUNTING') NOT NULL,
adm_diploma VARCHAR(200) NOT NULL,
PRIMARY KEY (adm_AT),
CONSTRAINT WORKADMIN
FOREIGN KEY (adm_AT) REFERENCES worker(wrk_AT)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE manages(
mng_adm_AT CHAR(10) NOT NULL,
mng_br_code INT(11) NOT NULL,
PRIMARY KEY (mng_adm_AT, mng_br_code),
CONSTRAINT ADMMANAGE
FOREIGN KEY (mng_adm_AT) REFERENCES admin(adm_AT)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT BRMANAGE
FOREIGN KEY (mng_br_code) REFERENCES branch(br_code)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE driver(
drv_AT CHAR(10) NOT NULL,
drv_license ENUM('A','B','C','D') NOT NULL,
drv_route ENUM('LOCAL','ABROAD') NOT NULL,
drv_experience TINYINT(4) NOT NULL,
PRIMARY KEY (drv_AT),
CONSTRAINT WORKDRIVER 
FOREIGN KEY (drv_AT) REFERENCES worker(wrk_AT)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE guide(
gui_AT CHAR(10) NOT NULL,
gui_cv TEXT NOT NULL,
PRIMARY KEY (gui_AT),
CONSTRAINT WORKGUIDE
FOREIGN KEY (gui_AT) REFERENCES worker (wrk_AT)
ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE languages(
lng_gui_AT CHAR(10) NOT NULL,
lng_language VARCHAR(30) NOT NULL,
PRIMARY KEY (lng_gui_AT, lng_language),
CONSTRAINT GUILANGUAGE
FOREIGN KEY (lng_gui_AT) REFERENCES guide(gui_AT)
);

CREATE TABLE trip(
tr_id INT(11) NOT NULL,
tr_departure DATETIME NOT NULL,
tr_return DATETIME NOT NULL,
tr_maxseats TINYINT(4) NOT NULL,
tr_cost FLOAT(7,2) NOT NULL,
tr_br_code INT(11) NOT NULL,
tr_gui_AT CHAR(10) NOT NULL,
tr_drv_AT CHAR(10) NOT NULL,
PRIMARY KEY(tr_id),
CONSTRAINT BRANCHTRIP
FOREIGN KEY (tr_br_code) REFERENCES branch(br_code)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT GUIDETRIP
FOREIGN KEY (tr_gui_AT) REFERENCES guide(gui_AT)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT DRIVERTRIP
FOREIGN KEY (tr_drv_AT) REFERENCES driver(drv_AT)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE event(
ev_tr_id INT(11) NOT NULL,
ev_start DATETIME NOT NULL,
ev_end DATETIME NOT NULL,
ev_descr TEXT NOT NULL,
PRIMARY KEY(ev_tr_id, ev_start),
CONSTRAINT EVENTTRIP
FOREIGN KEY (ev_tr_id) REFERENCES trip(tr_id)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE reservation(
res_tr_id INT(11) NOT NULL,
res_seatnum TINYINT(4) NOT NULL,
res_name VARCHAR(20) DEFAULT 'unknown' NOT NULL,
res_lname VARCHAR(20) DEFAULT 'unknown' NOT NULL,
res_isadult ENUM('ADULT','MINOR') NOT NULL,
PRIMARY KEY(res_tr_id, res_seatnum),
CONSTRAINT TRIPRESERV
FOREIGN KEY (res_tr_id) REFERENCES trip(tr_id)
ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE destination (
dst_id INT(11) NOT NULL,
dst_name VARCHAR(50) NOT NULL,
dst_descr TEXT NOT NULL,
dst_rtype ENUM('LOCAL','ABROAD') NOT NULL,
dst_language VARCHAR(30) NOT NULL,
dst_location INT(11) ,
PRIMARY KEY(dst_id), 
CONSTRAINT DESTLOCATION
FOREIGN KEY (dst_location) REFERENCES destination(dst_id)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE travel_to(
to_tr_id INT(11) NOT NULL,
to_dst_id INT(11) NOT NULL,
to_arrival DATETIME NOT NULL,
to_departure DATETIME NOT NULL,
PRIMARY KEY(to_tr_id, to_dst_id),
CONSTRAINT TRIPTRAVEL
FOREIGN KEY (to_tr_id) REFERENCES trip(tr_id)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT TRAVELDEST
FOREIGN KEY (to_dst_id) REFERENCES destination(dst_id)
ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO branch VALUES
(1,'AGIOY ANDREOY','15','PATRA'),
(2,'EVELPIDWN','29','ATHINA'),
(3,'TSIMISKI','43','THESALONIKI');


INSERT INTO phones VALUES
(1,'2610659237'),
(1,'6946318647'),
(2,'2103262024'),
(2,'6932169687'),
(3,'2316052340'),
(3,'6923168945');

INSERT INTO worker VALUES
('DR423611','GIANNIS','PAPADOPOYLOS',850.00,1),
('DR383152','VASILIS','APOSTOLOY',872.25,1),
('DR521363','ANTONIA','OIKONOMOY',800.32,1),
('DR210364','MARIA','PAPANTONIOY',840.00,2),
('DR235065','ANTONIS','ALEXANDROPOYLOS',864.59,2),
('DR464236','GIANNIS','SIFAKIS',967.00,2),
('DR325067','ZOI','PAPADOPOYLOY',1053.34,3),
('DR325068','KONSTANTINA','PAPADOPOYLOY',1099.00,3),
('DR325069','LIANA','PAPAGEORGIOU',980.00,3),
('AD356581','KONSTANTINA','PATAKI',1000.00,1),
('AD736892','ALEXIS','OIKONOMOY',856.41,1),
('AD875913','ANDREAS','PAPPAS',790.36,1),
('AD512354','MARIOS','NIKOLOPOYLOS',868.53,2),
('AD321025','ANASTASIA','ALEXOPOYLOY',980.79,2),
('AD456736','GIORGOS','GEORGAKOPOYLOS',800.00,2),
('AD765667','MARINA','NINIS',832.76,3),
('AD765668','MARIA','GEORGOYLI',835.00,3),
('AD609519','ANDREAS','SOTIROPOYLOS',963.00,3),
('GU648981','DIMITRIS','PAPASTATHOPOYLOS',850.65,1),
('GU435342','VASILIS','APOSTOLOPOYLOS',852.87,1),
('GU678673','APOSTOLHS','MPOYGAS',750.87,1),
('GU768564','MANOS','KYRIAKOPOYLOS',900.50,2),
('GU128745','ALEXIS','GEORGOPOYLOS',890.70,2),
('GU986816','TASOS','GIANOYKAS',900.60,2),
('GU761207','GIORGOS','GIAMEOS',900.60,3),
('GU136088','ATHANASIA','ANTONIOY',810.00,3), 
('GU394459','GEWRGIA','ATHANASOPOYLOY',785.63,3);


INSERT INTO admin VALUES
('AD356581','ACCOUNTING','DIPLOMA OIKONOMIKON'),
('AD736892','ADMINISTRATIVE','DIPLOMA DIOIKISIS EPIXEIRISEON'),
('AD875913','LOGISTICS','DIPLOMA LOGISTIKIS'),
('AD512354','ADMINISTRATIVE','DIPLOMA DIOIKISIS EPIXEIRISEON'),
('AD321025','ACCOUNTING','DIPLOMA OIKONOMIKON'),
('AD456736','LOGISTICS','DIPLOMA LOGISTIKIS'),
('AD765667','LOGISTICS','DIPLOMA LOGISTIKIS');


INSERT INTO manages VALUES
('AD356581',1),
('AD512354',2),
('AD765667',3);


INSERT INTO  guide VALUES
('GU648981','cv 1'),
('GU435342','cv 2'),
('GU678673','cv 3'),
('GU768564','cv 4'),
('GU128745','cv 5'),
('GU986816','cv 6'),
('GU761207','cv 7'),
('GU136088','cv 8'),
('GU394459','cv 9');


INSERT INTO  languages VALUES
('GU648981','English,Spanish'),
('GU435342','English,French'),
('GU678673','English,German'),
('GU768564','English,Spanish'),
('GU128745','English,Spanish'),
('GU986816','English,German'),
('GU761207','English,German'),
('GU136088','English,Spanish'),
('GU394459','English,French');


INSERT INTO driver VALUES
('DR423611','D','LOCAL',12),
('DR383152','A','ABROAD',24),
('DR521363','C','LOCAL',29),
('DR210364','D','ABROAD',31),
('DR235065','A','ABROAD',50),
('DR464236','B','LOCAL',48),
('DR325067','D','LOCAL',60),
('DR325068','A','ABROAD',27),
('DR325069','D','LOCAL',9);

INSERT INTO trip VALUES
(1,'2023-01-05 12:00:00','2023-01-11 14:00:00',40,60.00,1,'GU648981','DR423611'),
(2,'2022-12-22 08:30:00','2022-12-26 21:30:00',36,30.00,1,'GU435342','DR383152'),
(3,'2023-02-09 09:00:00','2023-02-17 10:00:00',40,42.63,2,'GU768564','DR210364'),
(4,'2023-02-25 10:45:00','2023-03-01 12:15:00',42,28.79,3,'GU761207','DR325067'),
(5,'2023-01-17 13:15:00','2023-01-22 15:00:00',39,40.00,3,'GU136088','DR325068');


INSERT INTO event VALUES
(1,'2023-01-06 12:00:00','2023-01-07 17:00:00','Event 1.1 description'),
(1,'2023-01-08 08:30:00','2023-01-08 22:30:00','Event 1.2 description'),
(1,'2023-01-09 10:00:00','2023-01-10 14:00:00','Event 1.3 description'),
(2,'2022-12-23 10:40:00','2022-12-24 19:15:00','Event 2.1 description'),
(2,'2022-12-25 16:00:00','2022-12-26 14:45:00','Event 2.2 description'),
(3,'2023-02-10 10:30:00','2023-02-11 02:00:00','Event 3.1 description'),
(3,'2023-02-12 08:00:00','2023-02-13 16:00:00','Event 3.2 description'),
(3,'2023-02-14 12:15:00','2023-02-15 12:00:00','Event 3.3 description'),
(3,'2023-02-15 15:30:00','2023-02-16 20:00:00','Event 3.4 description'),
(4,'2023-02-26 16:15:00','2023-02-27 19:45:00','Event 4.1 description'),
(4,'2023-02-28 08:00:00','2023-02-28 19:45:00','Event 4.2 description'),
(5,'2023-01-18 09:00:00','2023-01-19 13:00:00','Event 5.1 description'),
(5,'2023-01-20 10:00:00','2023-01-21 17:00:00','Event 5.2 description');


INSERT INTO reservation VALUES
(1,1,'Paulos','Giannopoulos','ADULT'),
(1,2,'Thodoris','Stefanopoylos','ADULT'),
(1,3,'Ioanna','Stefanopoylou','MINOR'),
(1,4,'Stefanos','Giannakis','ADULT'),
(1,5,'Petros','Giannakis','MINOR'),
(2,1,'Aggeliki','Papandreoy','ADULT'),
(2,2,'Fotini','Papandreoy','MINOR'),
(2,3,'Athanasia','Apostolopoyloy','ADULT'),
(2,4,'Stela','Apostolopoyloy','MINOR'),
(2,5,'Thanasis','Aggelopoylos','ADULT'),
(2,6,'Thodora','Mixailidi','ADULT'),
(3,1,'Apostolis','Aggelopoylos','MINOR'),
(3,2,'Alexandra','Melanidoy','ADULT'),
(3,3,'Apostolia','Melanidoy','MINOR'),
(3,4,'Tasos','Sakos','ADULT'),
(3,5,'Eleonora','Sakoy','MINOR'),
(3,6,'Dimitrhs','Papanikolaos','ADULT'),
(3,7,'Pantelis','Georgakopoylos','ADULT'),
(3,8,'Anastasia','Papanikolaou','MINOR'),
(3,9,'Menelaos','Papaloykas','ADULT'),
(4,1,'Pantelis','Giannopoulos','ADULT'),
(4,2,'Kwstas','Stefanopoylos','ADULT'),
(4,3,'Ioanna','Mixalopoyloy','ADULT'),
(4,4,'Orestis','Giannakis','ADULT'),
(4,5,'Thanasis','Giannopoulos','MINOR'),
(5,1,'Pinelopi','Papandreoy','ADULT'),
(5,2,'Fotini','Mixalopoyloy','ADULT'),
(5,3,'Athanasia','Apostoloy','ADULT'),
(5,4,'Stefania','Aggelopoyloy','MINOR'),
(5,5,'Marios','Aggelopoylos','ADULT'),
(5,6,'Domna','Mixailidi','ADULT'),
(5,7,'Apostolis','Metaxas','MINOR'),
(5,8,'Alexia','Metaxa','ADULT'),
(5,9,'Apostolia','Papadopoyloy','MINOR'),
(5,10,'Tasos','Papadopoylos','ADULT'),
(5,11,'Elenh','Papadopouloy','MINOR'),
(5,12,'Dimitra','Papanikolaoy','ADULT'),
(5,13,'Andreas','Georgakopoylos','ADULT'),
(5,14,'Anastasia','Papaloyka','MINOR'),
(5,15,'Anastasis','Papaloykas','ADULT');


INSERT INTO destination VALUES
(1,'USA','Destination 1 description','ABROAD','English',NULL),
(2,'Greece','Destination 2 description','LOCAL','Greek',NULL),
(3,'New York','Destination 3 description','ABROAD','English',1),
(4,'Los Angeles','Destination 4 description','ABROAD','English',1),
(5,'Crete','Destination 5 description','LOCAL','Greek',2);


INSERT INTO travel_to VALUES
(1,1,'2023-01-05 22:00:00','2023-01-11 04:00:00'),
(2,2,'2022-12-22 11:30:00','2022-12-26 18:30:00'),
(3,3,'2023-02-09 18:00:00','2023-02-17 01:00:00'),
(4,4,'2023-02-25 22:45:00','2023-03-01 00:15:00'),
(5,5,'2023-01-17 16:15:00','2023-01-22 12:00:00');


INSERT INTO worker Values
('IT326491','DIONYSIS','KALAITZAKIS', 1000.00, 1),
('IT315482','KYRIAKI','KEFALA',1125.00,2),
('IT231563','STEFANIA','KARYDI',967.56,3),
('IT497714','GIORGOS','PAPADOPOYLOS',890.50,1),
('IT234415','MANOS','PAPALIMNEOS',920.60,2),
('IT435616','VASILIS','TSIRIKOS',1000.00,3);

CREATE TABLE it(
IT_AT CHAR(10) NOT NULL,
IT_password CHAR(10) DEFAULT 'password' NOT NULL,
IT_start_date DATETIME NOT NULL,
IT_end_date DATETIME, 
PRIMARY KEY (IT_AT),
CONSTRAINT ITWORKER
FOREIGN KEY (IT_AT) REFERENCES worker(wrk_AT)
ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO it Values
('IT326491',DEFAULT,'2013-05-18 00:00',NULL),
('IT315482',DEFAULT,'2012-12-29 00:00',NULL),
('IT231563',DEFAULT,'2018-10-13 00:00',NULL),
('IT497714',DEFAULT,'2010-02-11 00:00',NULL),
('IT234415',DEFAULT,'2003-09-10 00:00',NULL),
('IT435616',DEFAULT,'2016-07-25 00:00',NULL);

CREATE TABLE log(
log_AT CHAR(10) NOT NULL,
table_trip ENUM('INSERT','UPDATE','DELETE'),
trip_last_update DATETIME,
table_reservation ENUM('INSERT','UPDATE','DELETE'),
reservation_last_update DATETIME,
table_event ENUM('INSERT','UPDATE','DELETE'),
event_last_update DATETIME,
table_travel_to ENUM('INSERT','UPDATE','DELETE'),
travel_to_last_update DATETIME,
table_destination ENUM('INSERT','UPDATE','DELETE'),
destination_last_update DATETIME,
PRIMARY KEY (log_AT),
CONSTRAINT LOGIT
FOREIGN KEY (log_AT) REFERENCES it(IT_AT)
ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO log(log_AT) VALUES 
(‘IT326491’),
(‘IT315482’),
(‘IT231563’),
(‘IT497714’),
(‘IT234415’),
(‘IT435616’);


CREATE TABLE offers(
offer_id INT(11) NOT NULL,
offer_start_date DATETIME NOT NULL,
offer_end_time DATETIME NOT NULL,
offer_cost FLOAT(7,2) NOT NULL,
offer_dst_id INT(11) NOT NULL,
PRIMARY KEY (offer_id),
CONSTRAINT OFFERDESTINATION
FOREIGN KEY (offer_dst_id) REFERENCES destination(dst_id)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE reservation_offers(
reservation_id INT(11) NOT NULL,
res_name VARCHAR(20) NOT NULL,
res_lastname VARCHAR(20) NOT NULL,
res_offer_id INT(11) NOT NULL,
adv_pay FLOAT(7,2) NOT NULL,
PRIMARY KEY (reservation_id),
CONSTRAINT RESOFFER
FOREIGN KEY (res_offer_id) REFERENCES offers(offer_id)
ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO destination VALUES
(6,'Miami','Destination 6 description','ABROAD','ENGLISH',1),
(7,'San Francisko', 'Destination 7 description','ABROAD','ENGLISH',1),
(8,'Las Vegas','Destination 8 description','ABROAD','ENGLISH',1);

INSERT INTO destination VALUES
(6,'Miami','Destination 6 description','ABROAD','ENGLISH',1),
(7,'San Francisko', 'Destination 7 description','ABROAD','ENGLISH',1),
(8,'Las Vegas','Destination 8 description','ABROAD','ENGLISH',1);


DROP PROCEDURE IF EXISTS new_driver;
DELIMITER $
CREATE PROCEDURE new_driver(new_AT CHAR(10),new_name VARCHAR(20),new_lastname VARCHAR(20),new_salary FLOAT(7,2),new_license ENUM('A','B','C','D'),new_route ENUM('LOCAL','ABROAD'),new_experience TINYINT(4) )
BEGIN
DECLARE num_of_drv_1 INT;
DECLARE num_of_drv_2 INT;
DECLARE num_of_drv_3 INT;

SELECT count(*) INTO num_of_drv_1
FROM driver INNER JOIN worker on
drv_AT=wrk_AT where wrk_br_code=1;
SELECT count(*) INTO num_of_drv_2
FROM driver INNER JOIN worker on
drv_AT=wrk_AT where wrk_br_code=2;
SELECT count(*) INTO  num_of_drv_3
FROM driver INNER JOIN worker on
drv_AT=wrk_AT where wrk_br_code=3;

IF(num_of_drv_1<=num_of_drv_2) THEN
	IF(num_of_drv_1<=num_of_drv_3) THEN
	INSERT INTO worker VALUES(new_AT, new_name, new_lastname, new_salary, 1);
	INSERT INTO driver VALUES(new_AT, new_license, new_route, new_experience);
	ELSEIF(num_of_drv_3<num_of_drv_1) THEN
	INSERT INTO worker VALUES(new_AT, new_name, new_lastname, new_salary, 3);
	INSERT INTO driver VALUES(new_AT, new_license, new_route, new_experience);
	END IF;
ELSEIF(num_of_drv_2<num_of_drv_1) THEN
	IF(num_of_drv_2<=num_of_drv_3) THEN
	INSERT INTO worker VALUES(new_AT, new_name, 	new_lastname, new_salary, 2);
	INSERT INTO driver VALUES(new_AT, new_license, new_route, new_experience);
	ELSEIF(num_of_drv_3<num_of_drv_2) THEN
	INSERT INTO worker VALUES(new_AT, new_name, 	new_lastname, new_salary, 3);
	INSERT INTO driver VALUES(new_AT, new_license, new_route, new_experience);
	END IF;
END IF;
END$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_trip;
DELIMITER $
CREATE PROCEDURE get_trip(br_trip INT, start_date DATETIME, end_date DATETIME)
BEGIN
DECLARE date_begin DATETIME;
DECLARE res_seats INT;
DECLARE max_seats INT;
DECLARE empty_seats INT;
DECLARE dr_name VARCHAR(20);
DECLARE dr_lname VARCHAR(20);
DECLARE gu_name VARCHAR(20);
DECLARE gu_lname VARCHAR(20);
DECLARE trip_cost FLOAT(7,2);
DECLARE date_end DATETIME;
DECLARE finishedflag INT;
DECLARE costcursor CURSOR FOR
SELECT tr_cost  FROM trip WHERE 
tr_br_code=br_trip;
DECLARE dateendcursor CURSOR FOR
SELECT tr_return FROM trip 
WHERE tr_br_code=br_trip;
DECLARE datebegincursor CURSOR FOR
SELECT tr_departure FROM trip 
WHERE tr_br_code=br_trip;
DECLARE rescursor CURSOR FOR
SELECT count(res_seatnum) FROM reservation 
INNER JOIN trip ON res_tr_id=tr_id 
WHERE tr_br_code=br_trip group by tr_id;
DECLARE maxcursor CURSOR FOR
SELECT tr_maxseats FROM trip 
WHERE tr_br_code=br_trip;
DECLARE drcursor CURSOR FOR
SELECT wrk_name, wrk_lname FROM worker 
INNER JOIN driver ON wrk_AT=drv_AT 
INNER JOIN trip ON drv_AT=tr_drv_AT 
WHERE tr_br_code=br_trip;
DECLARE gucursor CURSOR FOR
SELECT wrk_name, wrk_lname FROM worker 
INNER JOIN guide ON wrk_AT=gui_AT 
INNER JOIN trip ON gui_AT=tr_gui_AT 
WHERE tr_br_code=br_trip;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET finishedflag=0;

OPEN costcursor;
OPEN dateendcursor;
OPEN datebegincursor;
OPEN rescursor;
OPEN maxcursor;
OPEN drcursor;
OPEN gucursor;

REPEAT
FETCH costcursor INTO trip_cost;
FETCH dateendcursor INTO date_end;
FETCH datebegincursor INTO date_begin;
FETCH rescursor INTO res_seats;
FETCH maxcursor INTO max_seats;
FETCH drcursor INTO dr_name, dr_lname;
FETCH gucursor INTO gu_name, gu_lname;
IF (finishedflag=0) THEN
  IF (start_date<=date_begin AND date_begin<=end_date) THEN
  SET empty_seats=max_seats-res_seats;
  SELECT trip_cost AS 'trip cost', max_seats AS 'max seats', res_seats AS 'seats reserved', empty_seats AS 'seats available', dr_name AS 'driver name', dr_lname AS 'driver lastname', gu_name AS 'guide name', gu_lname AS 'guide lastname', date_begin AS 'departure date', date_end AS 'return date';
  END IF;
END IF;
UNTIL (finishedflag=1)
END REPEAT;
CLOSE costcursor;
CLOSE dateendcursor;
CLOSE datebegincursor;
CLOSE rescursor;
CLOSE maxcursor;
CLOSE drcursor;
CLOSE gucursor;
END$
DELIMITER ;

DROP PROCEDURE IF EXISTS del_admin;
DELIMITER $
CREATE PROCEDURE del_admin(ad_name VARCHAR(20), ad_lname VARCHAR(20))
BEGIN
DECLARE manager_AT CHAR(10);
DECLARE admin_AT CHAR(10);
SELECT adm_AT INTO admin_AT 
FROM worker INNER JOIN admin ON wrk_AT=adm_AT 
WHERE wrk_name=ad_name AND wrk_lname=ad_lname;
SELECT mng_adm_AT INTO manager_AT 
FROM worker INNER JOIN admin ON wrk_AT=adm_AT 
INNER JOIN manages ON adm_AT=mng_adm_AT 
WHERE wrk_name=ad_name AND wrk_lname=ad_lname;
IF(admin_AT IS NOT NULL) THEN
IF(manager_AT IS NOT NULL) THEN
SIGNAL SQLSTATE VALUE '45000'
SET MESSAGE_TEXT = 'Admin given is manager and cannot be deleted';
ELSE
DELETE FROM worker WHERE wrk_AT=admin_AT;
END IF;
ELSE
SIGNAL SQLSTATE VALUE '45000'
SET MESSAGE_TEXT = 'Person given is not an admin';
END IF;
END$
DELIMITER ;

DROP PROCEDURE IF EXISTS customer_reservation;
DELIMITER $
CREATE PROCEDURE customer_reservation(begin_cost INT,end_cost INT)
BEGIN

SELECT res_name AS name,res_lastname AS lastname 
FROM reservation_offers WHERE adv_pay>=begin_cost 
AND adv_pay<=end_cost;
END$
DELIMITER ;


Παραδειγματα:
call customer_reservation(150,165);

create index resoffers on reservation_offers(res_name,res_lastname);
call customer_reservation(150,165);



DROP PROCEDURE IF EXISTS same_lastname;
DELIMITER $
CREATE PROCEDURE same_lastname(person_lname VARCHAR(30))
BEGIN
DECLARE j INT;
DECLARE i INT;
SELECT count(*) INTO i FROM offers;

SET j=1;

REPEAT
SELECT res_name AS name,res_lastname AS lastname,res_offer_id,count(*) AS number_of_customers 
FROM reservation_offers 
WHERE res_lastname=person_lname AND res_offer_id=j 
GROUP BY res_name;
SET j=j+1;
UNTIL(j=i+1)
END REPEAT;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_insert_trip;
DELIMITER $
CREATE TRIGGER log_insert_trip 
AFTER INSERT ON trip
FOR EACH ROW
BEGIN
IF(new.tr_br_code=1) THEN
UPDATE log SET 
table_trip='INSERT',trip_last_update=NOW()
WHERE log_AT='IT497714';
ELSEIF(new.tr_br_code=2) THEN
UPDATE log SET 
table_trip='INSERT',trip_last_update=NOW() 
WHERE log_AT='IT234415';
ELSEIF(new.tr_br_code=3) THEN
UPDATE log SET 
table_trip='INSERT',trip_last_update=NOW() 
WHERE log_AT='IT435616';
END IF;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_update_trip;
DELIMITER $
CREATE TRIGGER log_update_trip 
AFTER UPDATE ON trip
FOR EACH ROW
BEGIN
IF(old.tr_br_code=1) THEN
UPDATE log SET 
table_trip='UPDATE',trip_last_update=NOW()
WHERE log_AT='IT326491';
ELSEIF(old.tr_br_code=2) THEN
UPDATE log SET 
table_trip='UPDATE',trip_last_update=NOW() 
WHERE log_AT='IT315482';
ELSEIF(old.tr_br_code=3) THEN
UPDATE log SET 
table_trip='UPDATE',trip_last_update=NOW() 
WHERE log_AT='IT231563';
END IF;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_delete_trip; 
DELIMITER $ 
CREATE TRIGGER log_delete_trip 
AFTER DELETE ON trip 
FOR EACH ROW 
BEGIN 
IF(old.tr_br_code=1) THEN 
UPDATE log SET 
table_trip='DELETE', trip_last_update=NOW() 
WHERE log_AT='IT326491'; 
ELSEIF(old.tr_br_code=2) THEN 
UPDATE log 
SET table_trip='DELETE', trip_last_update=NOW() 
WHERE log_AT='IT315482'; 
ELSEIF(old.tr_br_code=3) THEN 
UPDATE log SET 
table_trip='DELETE', trip_last_update=NOW()
WHERE log_AT='IT231563'; 
END IF; 
END$ 
DELIMITER ;



DROP TRIGGER IF EXISTS log_insert_reservation;
DELIMITER $
CREATE TRIGGER log_insert_reservation 
AFTER INSERT ON reservation
FOR EACH ROW
BEGIN
DECLARE branch_code INT;
DECLARE finishedflag INT;
DECLARE brcodecursor CURSOR FOR
SELECT tr_br_code 
FROM trip INNER JOIN reservation 
ON tr_id=res_tr_id WHERE res_tr_id=new.res_tr_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET finishedflag=0;

OPEN brcodecursor;

REPEAT
FETCH brcodecursor INTO branch_code;
IF (finishedflag=0) THEN
IF(branch_code=1) THEN
UPDATE log SET 
table_reservation='INSERT',reservation_last_update=NOW() 
WHERE log_AT='IT497714';
ELSEIF(branch_code=2) THEN
UPDATE log SET 
table_reservation='INSERT',reservation_last_update=NOW() 
WHERE log_AT='IT234415';
ELSEIF(branch_code=3) THEN
UPDATE log SET 
table_reservation='INSERT',reservation_last_update=NOW() 
WHERE log_AT='IT435616';
END IF;
END IF;
UNTIL (finishedflag=1)
END REPEAT;
CLOSE brcodecursor;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_update_reservation;
DELIMITER $
CREATE TRIGGER log_update_reservation 
AFTER UPDATE ON reservation
FOR EACH ROW
BEGIN
DECLARE branch_code INT;
DECLARE finishedflag INT;
DECLARE brcodecursor CURSOR FOR
SELECT tr_br_code 
FROM trip INNER JOIN reservation 
ON tr_id=res_tr_id WHERE res_tr_id=new.res_tr_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET finishedflag=0;

OPEN brcodecursor;

REPEAT
FETCH brcodecursor INTO branch_code;
IF (finishedflag=0) THEN
IF(branch_code=1) THEN
UPDATE log SET 
table_reservation='UPDATE',reservation_last_update=NOW()
WHERE log_AT='IT326491';
ELSEIF(branch_code=2) THEN
UPDATE log SET 
table_reservation='UPDATE',reservation_last_update=NOW()
WHERE log_AT='IT315482';
ELSEIF(branch_code=3) THEN
UPDATE log SET 
table_reservation='UPDATE',reservation_last_update=NOW()
WHERE log_AT='IT231563';
END IF;
END IF;
UNTIL (finishedflag=1)
END REPEAT;
CLOSE brcodecursor;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_delete_reservation;
DELIMITER $
CREATE TRIGGER log_delete_reservation 
BEFORE DELETE ON reservation
FOR EACH ROW
BEGIN
DECLARE branch_code INT;
DECLARE finishedflag INT;
DECLARE brcodecursor CURSOR FOR
SELECT tr_br_code 
FROM trip INNER JOIN reservation 
ON tr_id=res_tr_id WHERE res_tr_id=old.res_tr_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET finishedflag=0;

OPEN brcodecursor;

REPEAT
FETCH brcodecursor INTO branch_code;
IF (finishedflag=0) THEN
IF(branch_code=1) THEN
UPDATE log SET 
table_reservation='DELETE',reservation_last_update=NOW()
WHERE log_AT='IT326491';
ELSEIF(branch_code=2) THEN
UPDATE log SET 
table_reservation='DELETE',reservation_last_update=NOW()WHERE log_AT='IT315482';
ELSEIF(branch_code=3) THEN
UPDATE log SET 
table_reservation='DELETE',reservation_last_update=NOW()WHERE log_AT='IT231563';
END IF;
END IF;
UNTIL (finishedflag=1)
END REPEAT;
CLOSE brcodecursor;
END$
DELIMITER ;


DROP TRIGGER IF EXISTS log_insert_event;
DELIMITER $
CREATE TRIGGER log_insert_event 
AFTER INSERT ON event
FOR EACH ROW
BEGIN
DECLARE branch_code INT;
DECLARE finishedflag INT;
DECLARE brcodecursor CURSOR FOR
SELECT tr_br_code FROM event 
INNER JOIN trip ON ev_tr_id=tr_id
WHERE ev_tr_id=new.ev_tr_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET finishedflag=0;

OPEN brcodecursor;

REPEAT
FETCH brcodecursor INTO branch_code;
IF (finishedflag=0) THEN
IF(branch_code=1) THEN
UPDATE log SET 
table_event='INSERT',event_last_update=NOW()
WHERE log_AT='IT497714';
ELSEIF(branch_code=2) THEN
UPDATE log SET 
table_event='INSERT',event_last_update=NOW()
WHERE log_AT='IT234415';
ELSEIF(branch_code=3) THEN
UPDATE log SET 
table_event='INSERT',event_last_update=NOW()
WHERE log_AT='IT435616';
END IF;
END IF;
UNTIL (finishedflag=1)
END REPEAT;
CLOSE brcodecursor;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_update_event;
DELIMITER $ 
CREATE TRIGGER log_update_event 
AFTER UPDATE ON event 
FOR EACH ROW 
BEGIN 
DECLARE branch_code INT; 
DECLARE finishedflag INT; 
DECLARE brcodecursor CURSOR FOR 
SELECT tr_br_code FROM event 
INNER JOIN trip ON ev_tr_id=tr_id 
WHERE ev_tr_id=old.ev_tr_id; 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET finishedflag=0; 

OPEN brcodecursor; 

REPEAT 
FETCH brcodecursor INTO branch_code; 
IF (finishedflag=0) THEN 
IF(branch_code=1) THEN 
UPDATE log SET table_event='UPDATE',event_last_update=NOW() 
WHERE log_AT='IT326491'; 
ELSEIF(branch_code=2) THEN 
UPDATE log SET table_event='UPDATE',event_last_update=NOW() 
WHERE log_AT='IT315482'; 
ELSEIF(branch_code=3) THEN 
UPDATE log SET table_event='UPDATE',event_last_update=NOW() 
WHERE log_AT='IT231563'; 
END IF; 
END IF; 
UNTIL (finishedflag=1) 
END REPEAT; 
CLOSE brcodecursor; 
END$ 
DELIMITER ;

DROP TRIGGER IF EXISTS log_delete_event;
DELIMITER $ 
CREATE TRIGGER log_delete_event 
BEFORE DELETE ON event 
FOR EACH ROW 
BEGIN 
DECLARE branch_code INT; 
DECLARE finishedflag INT; 
DECLARE brcodecursor CURSOR FOR 
SELECT tr_br_code FROM event 
INNER JOIN trip ON ev_tr_id=tr_id 
WHERE ev_tr_id=old.ev_tr_id; 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1; 

SET finishedflag=0; 

OPEN brcodecursor; 

REPEAT 
FETCH brcodecursor INTO branch_code; 
IF (finishedflag=0) THEN 
IF(branch_code=1) THEN 
UPDATE log SET table_event='DELETE',event_last_update=NOW() 
WHERE log_AT='IT326491'; 
ELSEIF(branch_code=2) THEN 
UPDATE log SET table_event='DELETE',event_last_update=NOW() 
WHERE log_AT='IT315482'; 
ELSEIF(branch_code=3) THEN 
UPDATE log SET table_event='DELETE',event_last_update=NOW() 
WHERE log_AT='IT231563'; 
END IF; 
END IF; 
UNTIL (finishedflag=1) 
END REPEAT; 
CLOSE brcodecursor; 
END$ 
DELIMITER ;

DROP TRIGGER IF EXISTS log_insert_travel_to;
DELIMITER $
CREATE TRIGGER log_insert_travel_to 
AFTER INSERT ON travel_to
FOR EACH ROW
BEGIN
DECLARE branch_code INT;
DECLARE finishedflag INT;
DECLARE brcodecursor CURSOR FOR
SELECT tr_br_code FROM travel_to 
INNER JOIN trip ON to_tr_id=tr_id
WHERE to_tr_id=new.to_tr_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET finishedflag=0;

OPEN brcodecursor;

REPEAT
FETCH brcodecursor INTO branch_code;
IF (finishedflag=0) THEN
IF(branch_code=1) THEN
UPDATE log SET 
table_travel_to='INSERT',travel_to_last_update=NOW()
WHERE log_AT='IT497714';
ELSEIF(branch_code=2) THEN
UPDATE log SET 
table_travel_to='INSERT',travel_to_last_update=NOW()
WHERE log_AT='IT234415';
ELSEIF(branch_code=3) THEN
UPDATE log SET 
table_travel_to='INSERT',travel_to_last_update=NOW()
WHERE log_AT='IT435616';
END IF;
END IF;
UNTIL (finishedflag=1)
END REPEAT;
CLOSE brcodecursor;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_update_travel_to;
DELIMITER $ 
CREATE TRIGGER log_update_travel_to 
AFTER UPDATE ON travel_to 
FOR EACH ROW 
BEGIN 
DECLARE branch_code INT; 
DECLARE finishedflag INT; 
DECLARE brcodecursor CURSOR FOR 
SELECT tr_br_code FROM travel_to 
INNER JOIN trip ON to_tr_id=tr_id 
WHERE to_tr_id=old.to_tr_id; 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET finishedflag=0; 

OPEN brcodecursor; 

REPEAT 
FETCH brcodecursor INTO branch_code; 
IF (finishedflag=0) THEN 
IF(branch_code=1) THEN 
UPDATE log SET 
table_travel_to='UPDATE',travel_to_last_update=NOW() 
WHERE log_AT='IT326491'; 
ELSEIF(branch_code=2) THEN 
UPDATE log SET 
table_travel_to='UPDATE',travel_to_last_update=NOW() 
WHERE log_AT='IT315482'; 
ELSEIF(branch_code=3) THEN 
UPDATE log SET 
table_travel_to='UPDATE',travel_to_last_update=NOW() 
WHERE log_AT='IT231563'; 
END IF; 
END IF; 
UNTIL (finishedflag=1) END REPEAT; 
CLOSE brcodecursor; 
END$ 
DELIMITER ;

DROP TRIGGER IF EXISTS log_delete_travel_to; 
DELIMITER $ 
CREATE TRIGGER log_delete_travel_to 
BEFORE DELETE ON travel_to 
FOR EACH ROW 
BEGIN 
DECLARE branch_code INT; 
DECLARE finishedflag INT; 
DECLARE brcodecursor CURSOR FOR 
SELECT tr_br_code FROM travel_to 
INNER JOIN trip ON to_tr_id=tr_id 
WHERE to_tr_id=old.to_tr_id; 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1; 

SET finishedflag=0; 

OPEN brcodecursor; 

REPEAT 
FETCH brcodecursor INTO branch_code; 
IF(finishedflag=0) THEN 
IF(branch_code=1) THEN 
UPDATE log SET 
table_travel_to='DELETE',travel_to_last_update=NOW() 
WHERE log_AT='IT326491'; 
ELSEIF(branch_code=2) THEN 
UPDATE log SET 
table_travel_to='DELETE',travel_to_last_update=NOW() 
WHERE log_AT='IT315482'; 
ELSEIF(branch_code=3) THEN 
UPDATE log SET 
table_travel_to='DELETE',travel_to_last_update=NOW() 
WHERE log_AT='IT231563'; 
END IF; 
END IF; 
UNTIL (finishedflag=1) END REPEAT; 
CLOSE brcodecursor; 
END$ 
DELIMITER ; 

DROP TRIGGER IF EXISTS log_insert_destination;
DELIMITER $
CREATE TRIGGER log_insert_destination 
AFTER INSERT ON destination
FOR EACH ROW
BEGIN
UPDATE log SET 
table_destination='INSERT',destination_last_update=NOW()
WHERE log_AT='IT497714';
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_update_destination;
DELIMITER $
CREATE TRIGGER log_update_destination 
AFTER UPDATE ON destination
FOR EACH ROW
BEGIN
DECLARE branch_code INT;
DECLARE finishedflag INT;
DECLARE s INT;
DECLARE brcodecursor CURSOR FOR
SELECT tr_br_code FROM destination 
INNER JOIN travel_to ON dst_id=to_dst_id 
INNER JOIN trip ON to_tr_id=tr_id
WHERE dst_id=old.dst_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET s=0;
SET finishedflag=0;

OPEN brcodecursor;

REPEAT
FETCH brcodecursor INTO branch_code;
IF(finishedflag=0) THEN
IF(branch_code=1) THEN
UPDATE log SET 
table_destination='UPDATE',destination_last_update=NOW()
WHERE log_AT='IT326491';
SET s=1;
ELSEIF(branch_code=2) THEN 
UPDATE log SET 
table_destination='UPDATE',destination_last_update=NOW()
WHERE log_AT='IT315482'; 
SET s=1;
ELSEIF(branch_code=3) THEN 
UPDATE log SET 
table_destination='UPDATE',destination_last_update=NOW()
WHERE log_AT='IT231563';
SET s=1;
END IF;
END IF;
UNTIL (finishedflag=1)
END REPEAT;
CLOSE brcodecursor;
IF(s=0) THEN
UPDATE log SET table_destination='UPDATE',destination_last_update=NOW()
WHERE log_AT='IT326491';
END IF;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_delete_destination;
DELIMITER $
CREATE TRIGGER log_delete_destination 
BEFORE DELETE ON destination
FOR EACH ROW
BEGIN
DECLARE branch_code INT;
DECLARE finishedflag INT;
DECLARE s INT;
DECLARE brcodecursor CURSOR FOR
SELECT tr_br_code FROM destination 
INNER JOIN travel_to ON dst_id=to_dst_id 
INNER JOIN trip ON to_tr_id=tr_id
WHERE dst_id=old.dst_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finishedflag=1;

SET s=0;
SET finishedflag=0;

OPEN brcodecursor;

REPEAT
FETCH brcodecursor INTO branch_code;
IF(finishedflag=0) THEN
IF(branch_code=1) THEN 
UPDATE log SET 
table_destination='DELETE',destination_last_update=NOW()
WHERE log_AT='IT326491';
SET s=1;
ELSEIF(branch_code=2) THEN 
UPDATE log SET 
table_destination='DELETE',destination_last_update=NOW()
WHERE log_AT='IT315482';
SET s=1; 
ELSEIF(branch_code=3) THEN 
UPDATE log SET 
table_destination='DELETE',destination_last_update=NOW()
WHERE log_AT='IT231563';
SET s=1;
END IF;
END IF;
UNTIL (finishedflag=1)
END REPEAT;
CLOSE brcodecursor;
IF(s=0) THEN
UPDATE log SET table_destination='UPDATE',destination_last_update=NOW()
WHERE log_AT='IT326491';
END IF;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS prevent_trip_update;
DELIMITER $
CREATE TRIGGER prevent_trip_update
BEFORE UPDATE ON trip
FOR EACH ROW
BEGIN
DECLARE tr_res INT;
SELECT count(*) INTO tr_res
FROM reservation INNER JOIN trip 
ON res_tr_id=tr_id WHERE tr_id=old.tr_id;

IF(old.tr_departure!=new.tr_departure) THEN
IF(tr_res>0) THEN
SIGNAL SQLSTATE VALUE '45000'
SET MESSAGE_TEXT ='Cannot change departure because there are already reservations for this trip.';
END IF;
END IF;
IF(old.tr_return!=new.tr_return) THEN
IF(tr_res>0) THEN
SIGNAL SQLSTATE VALUE '45000'
SET MESSAGE_TEXT ='Cannot change return because there are already reservations for this trip.';
END IF;
END IF;
IF(old.tr_cost!=new.tr_cost) THEN
IF(tr_res>0) THEN
SIGNAL SQLSTATE VALUE '45000'
SET MESSAGE_TEXT ='Cannot change cost because there are already reservations for this trip.';
END IF;
END IF;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS prevent_salary_decrease;
DELIMITER $
CREATE TRIGGER prevent_salary_decrease
BEFORE UPDATE ON worker
FOR EACH ROW
BEGIN

IF(new.wrk_salary<old.wrk_salary) THEN
SIGNAL SQLSTATE VALUE '45000'
SET MESSAGE_TEXT ='Cannot lower salary of worker.';
END IF;
END$
DELIMITER ;

