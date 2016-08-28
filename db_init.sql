-- INITIALIZE DB

USE c9;
-- USE samil;



-- DROP THINGS -----------------------------------------------------------------------------

-- DROP ALL TABLES
DROP TABLE IF EXISTS test;
DROP TABLE IF EXISTS passcode;
DROP TABLE IF EXISTS session;

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





-- INITIAL DATA CREATION --------------------------------------------------------------------------

-- INSERT INITIAL PASSCODE
-- INSERT INTO passcode (passcode, whencreated, isvalid) VALUES ('98408787', CONVERT_TZ(NOW(), '+00:00', '+09:00'), b'1');
INSERT INTO passcode (passcode, whencreated, isvalid) VALUES ('0', CONVERT_TZ(NOW(), '+00:00', '+09:00'), b'1');







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