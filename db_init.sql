-- INITIALIZE DB

USE c9;
-- USE samil;

-- DROP ALL TABLES
DROP TABLE IF EXISTS test;
DROP TABLE IF EXISTS passcode;

-- DROP ALL FUNCTIONS
DROP FUNCTION IF EXISTS checkpass;
DROP FUNCTION IF EXISTS changepass;

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

-- INSERT INITIAL PASSCODE
-- INSERT INTO passcode (passcode, whencreated, isvalid) VALUES ('98408787', CONVERT_TZ(NOW(), '+00:00', '+09:00'), b'1');
INSERT INTO passcode (passcode, whencreated, isvalid) VALUES ('0', CONVERT_TZ(NOW(), '+00:00', '+09:00'), b'1');

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

DELIMITER ;