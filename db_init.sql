-- INITIALIZE DB

USE c9;
-- USE samil;



-- DROP THINGS -----------------------------------------------------------------------------

-- DROP ALL TABLES
DROP TABLE IF EXISTS test;
DROP TABLE IF EXISTS passcode;
DROP TABLE IF EXISTS session;
DROP TABLE IF EXISTS building;
DROP TABLE IF EXISTS floor;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS roommeter;
DROP TABLE IF EXISTS floormeter;
DROP TABLE IF EXISTS floorbill;
DROP TABLE IF EXISTS roombill_calc;
DROP TABLE IF EXISTS infolog;
DROP TABLE IF EXISTS accesslog;


-- DROP ALL FUNCTIONS
DROP FUNCTION IF EXISTS checkpass;
DROP FUNCTION IF EXISTS changepass;
DROP FUNCTION IF EXISTS createsession;
DROP FUNCTION IF EXISTS checksessionkey;


-- TABLE CREATION --------------------------------------------------------------------------

-- TEST TABLE
CREATE TABLE test (theid INTEGER);

-- PASSCODE TABLE
CREATE TABLE passcode (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    passcode VARCHAR(255) NOT NULL,
    whencreated DATETIME NOT NULL,
    isvalid BIT(1) NOT NULL DEFAULT b'1',
    INDEX (isvalid,whencreated DESC),
    INDEX (passcode)
);

-- SESSION TABLE

CREATE TABLE session (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    sessionkey VARCHAR(255) NOT NULL UNIQUE KEY,
    whencreated DATETIME NOT NULL
);

-- INFOLOG TABLE

CREATE TABLE infolog (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    log VARCHAR(4096) NULL,
    whencreated DATETIME NOT NULL
);

-- ACCESSLOG TABLE

CREATE TABLE accesslog (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    useragent VARCHAR(1024) NOT NULL,
    log VARCHAR(4096) NULL,
    whencreated DATETIME NOT NULL
);

-- BUILDING TABLE

CREATE TABLE building (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE KEY
);

-- FLOOR TABLE

CREATE TABLE floor (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fk_buildingid INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE KEY
);

-- ROOM TABLE

CREATE TABLE room (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fk_floorid INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE KEY
);

-- ROOMMETER TABLE

CREATE TABLE roommeter (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fk_roomid INTEGER NOT NULL,
    metervalue INTEGER NOT NULL,
    yearmonth CHAR(6) NOT NULL
);

-- FLOORMETER TABLE

CREATE TABLE floormeter (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fk_floorid INTEGER NOT NULL,
    metervalue INTEGER NOT NULL,
    yearmonth CHAR(6) NOT NULL
);

-- FLOORBILL TABLE

CREATE TABLE floorbill (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fk_floorid INTEGER NOT NULL,
    billmoney INTEGER NOT NULL,
    yearmonth CHAR(6) NOT NULL
);

-- ROOMBILL TABLE

CREATE TABLE roombill_calc (
    theid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fk_roomid INTEGER NOT NULL,
    billmoney INTEGER NOT NULL,
    yearmonth CHAR(6) NOT NULL
);



-- INITIAL DATA CREATION --------------------------------------------------------------------------

-- INSERT INITIAL PASSCODE
-- INSERT INTO passcode (passcode, whencreated, isvalid) VALUES ('98408787', CONVERT_TZ(NOW(), '+00:00', '+09:00'), b'1');
INSERT INTO passcode (passcode, whencreated, isvalid) VALUES ('0', CONVERT_TZ(NOW(), '+00:00', '+09:00'), b'1');

INSERT INTO building (name) VALUES ('삼일오피스텔');
SELECT LAST_INSERT_ID() INTO @buildingid;

INSERT INTO floor (fk_buildingid, name) VALUES (@buildingid, 'B1층');
SELECT LAST_INSERT_ID() INTO @floorid;

INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 6603, '201603');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 7956, '201604');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 9138, '201605');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 10217, '201606');

INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 129670, '201604');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 116250, '201605');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 114930, '201606');

INSERT INTO room (fk_floorid, name) VALUES (@floorid, 'B111호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 9575, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 9581, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 9655, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 9735, '201606');




INSERT INTO floor (fk_buildingid, name) VALUES (@buildingid, '2층');
SELECT LAST_INSERT_ID() INTO @floorid;

INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 3438, '201602');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 4165, '201603');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 5143, '201604');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 6139, '201605');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 7154, '201606');

INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 100860, '201603');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 99500, '201604');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 100850, '201605');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 106760, '201606');

INSERT INTO room (fk_floorid, name) VALUES (@floorid, '203호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 8034, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 8044, '201606');


INSERT INTO room (fk_floorid, name) VALUES (@floorid, '204호');
SELECT LAST_INSERT_ID() INTO @roomid;


INSERT INTO room (fk_floorid, name) VALUES (@floorid, '209호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1869, '201602');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1879, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1931, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1982, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 2037, '201606');


INSERT INTO room (fk_floorid, name) VALUES (@floorid, '210호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7605, '201602');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7634, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7713, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7804, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7905, '201606');


INSERT INTO room (fk_floorid, name) VALUES (@floorid, '213호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7718, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7742, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7807, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7888, '201606');





INSERT INTO floor (fk_buildingid, name) VALUES (@buildingid, '3층');
SELECT LAST_INSERT_ID() INTO @floorid;

INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 3986, '201602');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 4871, '201603');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 5934, '201604');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 7011, '201605');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 8141, '201606');

INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 119410, '201603');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 108170, '201604');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 109290, '201605');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 118230, '201606');

INSERT INTO room (fk_floorid, name) VALUES (@floorid, '304호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO room (fk_floorid, name) VALUES (@floorid, '311호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 6850, '201602');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 6917, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7018, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7131, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7261, '201606');


INSERT INTO room (fk_floorid, name) VALUES (@floorid, '313호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 9936, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 26, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 136, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 246, '201606');





INSERT INTO floor (fk_buildingid, name) VALUES (@buildingid, '4층');
SELECT LAST_INSERT_ID() INTO @floorid;

INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 3962, '201602');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 4696, '201603');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 5615, '201604');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 6588, '201605');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 7683, '201606');

INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 101560, '201603');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 95120, '201604');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 99180, '201605');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 113070, '201606');

INSERT INTO room (fk_floorid, name) VALUES (@floorid, '406호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 4527, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 4557, '201606');


INSERT INTO room (fk_floorid, name) VALUES (@floorid, '407호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1252, '201606');

INSERT INTO room (fk_floorid, name) VALUES (@floorid, '411호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7938, '201602');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 7976, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 8042, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 8111, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 8181, '201606');

INSERT INTO room (fk_floorid, name) VALUES (@floorid, '413호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 9821, '201602');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 9826, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 9949, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 100, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 260, '201606');

INSERT INTO room (fk_floorid, name) VALUES (@floorid, '415호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 4149, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 4154, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 4215, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 4276, '201606');






INSERT INTO floor (fk_buildingid, name) VALUES (@buildingid, '5층');
SELECT LAST_INSERT_ID() INTO @floorid;

INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 5342, '201602');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 6565, '201603');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 7827, '201604');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 8940, '201605');
INSERT INTO floormeter (fk_floorid, metervalue, yearmonth) VALUES (@floorid, 10096, '201606');

INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 153800, '201603');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 122920, '201604');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 111870, '201605');
INSERT INTO floorbill (fk_floorid, billmoney, yearmonth) VALUES (@floorid, 120276, '201606');

INSERT INTO room (fk_floorid, name) VALUES (@floorid, '507호');
SELECT LAST_INSERT_ID() INTO @roomid;

INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1000, '201602');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1006, '201603');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1050, '201604');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1101, '201605');
INSERT INTO roommeter (fk_roomid, metervalue, yearmonth) VALUES (@roomid, 1161, '201606');



-- FUNCTIONS CREATION --------------------------------------------------------------------------

-- CREATE checkpass FUNCTION
DELIMITER $$

CREATE FUNCTION checkpass (passcode_in TEXT) RETURNS INTEGER
    BEGIN
        DECLARE returnval INTEGER;
        SELECT COUNT(theid) INTO returnval FROM passcode WHERE isvalid = b'1' AND passcode = passcode_in;
        RETURN returnval;
    END;
$$

-- CREATE changepass FUNCTION
CREATE FUNCTION changepass (old_passcode_in TEXT, new_passcode_in TEXT) RETURNS INTEGER
    BEGIN
        DECLARE returnval INTEGER;
        SELECT COUNT(theid) INTO returnval FROM passcode WHERE isvalid = b'1' AND passcode = old_passcode_in;
        IF returnval = 1 THEN
            UPDATE passcode SET isvalid = b'0';
            INSERT INTO passcode (passcode, whencreated, isvalid) VALUES (new_passcode_in, CONVERT_TZ(NOW(), '+00:00', '+09:00'), b'1');
        END IF;
        RETURN returnval;
    END;
$$

CREATE FUNCTION createsession () RETURNS TEXT
    BEGIN
        DECLARE new_sessionkey TEXT DEFAULT '';
        DECLARE random_ch TEXT DEFAULT '';
        DECLARE sessionkey_len INTEGER DEFAULT 48;
        DECLARE v_counter INTEGER DEFAULT 0;
        DECLARE key_exists INTEGER DEFAULT 1;
        
        WHILE key_exists > 0 DO
            WHILE v_counter < sessionkey_len DO
                SELECT substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', floor(rand()*36)+1, 1) INTO random_ch;
                SELECT concat(new_sessionkey, random_ch) INTO new_sessionkey;
                SELECT v_counter + 1 INTO v_counter;
            END WHILE;
    
            SELECT COUNT(theid) FROM session WHERE sessionkey = new_sessionkey INTO key_exists;    
            IF key_exists = 0 THEN
                INSERT INTO session (sessionkey, whencreated) VALUES (new_sessionkey, CONVERT_TZ(NOW(), '+00:00', '+09:00'));
            END IF;
        END WHILE;
        
        RETURN new_sessionkey;
    END;
$$

CREATE FUNCTION checksessionkey (sessionkey_in TEXT) RETURNS INTEGER
    BEGIN
        DECLARE returnval INTEGER;
        SELECT COUNT(theid) INTO returnval FROM 
            (SELECT theid, sessionkey FROM session ORDER BY whencreated DESC LIMIT 1) AS T1
        WHERE sessionkey = sessionkey_in;
        RETURN returnval;
    END;
$$


DELIMITER ;