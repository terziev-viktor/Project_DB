CREATE TABLE Staff ( 
egn VARCHAR(10) NOT NULL,
phone VARCHAR(13) ,
dep VARCHAR(120) NOT NULL,
bd DATE,
salary DOUBLE NOT NULL,
linear_manager VARCHAR(10),
PRIMARY KEY (egn));

-- Will act as a null value or default admin
INSERT INTO STAFF (EGN, PHONE, DEP, BD, SALARY, LINEAR_MANAGER ) VALUES ('0000000000', '0000000000', 'Default', '0001-01-01', 00.00, '0000000000');

CREATE TABLE Zones( 
zone_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
zone_floor INT NOT NULL,
zone_size DOUBLE,
PRIMARY KEY (zone_id));

CREATE TABLE Dep (
name VARCHAR(120) NOT NULL,
office INT,
manager VARCHAR(10) NOT NULL,
PRIMARY KEY (name));

INSERT INTO Dep (name, manager) VALUES('Default', '0000000000');

-- select * from dep;

CREATE TABLE Owners( 
owner_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
name VARCHAR(250) NOT NULL,
phone VARCHAR(13),
email VARCHAR(120),
PRIMARY KEY (owner_id) );

CREATE TABLE Contracts( 
contracts_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
price DOUBLE NOT NULL,
owner INT NOT NULL,
--FOREIGN KEY REFERENCES Owners(owner_id),
 zone_id INT NOT NULL,
-- FOREIGN KEY REFERENCES Zones(zones_id),
 stdate DATE,
endate DATE,
PRIMARY KEY (contracts_id));


ALTER TABLE STAFF FOREIGN KEY (dep) REFERENCES DEP (NAME) ON
UPDATE
	NO ACTION ON
	DELETE
	CASCADE;

ALTER TABLE STAFF ALTER COLUMN dep SET DEFAULT 'Default';

ALTER TABLE OWNERS ADD CONSTRAINT EMAIL CHECK (EMAIL LIKE '%@%.%');

ALTER TABLE OWNERS ADD CONSTRAINT PHONE CHECK ( 
(CASE
  WHEN LENGTH(RTRIM(TRANSLATE(PHONE, '*', ' 0123456789'))) = 0 
  THEN 1
  ELSE 2
END) = 1 OR PHONE = NULL);

ALTER TABLE STAFF ADD CONSTRAINT PHONE CHECK ( 
(CASE
  WHEN LENGTH(RTRIM(TRANSLATE(PHONE, '*', ' 0123456789'))) = 0 
  THEN 1
  ELSE 2
END) = 1 OR PHONE = NULL);

ALTER TABLE STAFF ADD CONSTRAINT SALARY CHECK (SALARY >= 0.0);

ALTER TABLE STAFF FOREIGN KEY (linear_manager) REFERENCES STAFF (egn);

ALTER TABLE DEP FOREIGN KEY (office) REFERENCES ZONES (zone_id);

ALTER TABLE DEP FOREIGN KEY (manager) REFERENCES STAFF (egn);

ALTER TABLE DEP ALTER COLUMN manager SET DEFAULT '0000000000';

ALTER TABLE CONTRACTS FOREIGN KEY (owner) REFERENCES OWNERS (owner_id);

ALTER TABLE CONTRACTS FOREIGN KEY (zone_id) REFERENCES ZONES (zone_id);