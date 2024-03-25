USE master
GO
IF DB_ID (N'Lab9') IS NOT NULL
DROP DATABASE Lab9
GO
-- Create a new database
CREATE DATABASE Lab9
    ON ( NAME = Lab9_dat, FILENAME = "/var/opt/mssql/data/dbs/Lab9dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab9_log, FILENAME = "/var/opt/mssql/data/logs/Lab9log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
USE Lab9

-- 1) Для одной из таблиц ЛР7 п.2 создать триггеры на вставку, удаление и добавление
IF OBJECT_ID('Lab9..Stores', 'U') IS NOT NULL
DROP TABLE Lab9..Stores
GO
CREATE TABLE Lab9..Stores (
    location_id INT NOT NULL PRIMARY KEY,
    location NVARCHAR(200) NOT NULL,
    work_hours TEXT  NULL,
    capacity NUMERIC(8,2) NOT NULL
)
IF OBJECT_ID('Lab9..Phone_Numbers', 'U') IS NOT NULL
DROP TABLE Lab9..Phone_Numbers
GO
CREATE TABLE Lab9..Phone_Numbers (
    phone_number_id INT IDENTITY(112, 112) NOT NULL PRIMARY KEY,
    location_id INT FOREIGN KEY
    REFERENCES Lab9..Stores(location_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    phone_number NVARCHAR(12) NOT NULL
)
GO
IF OBJECT_ID('dbo.PhoneNumInsertTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.PhoneNumInsertTrig
GO
CREATE TRIGGER PhoneNumInsertTrig ON Lab9..Phone_Numbers 
    INSTEAD OF INSERT 
    AS BEGIN
        DECLARE @total_insert_rows INT
        DECLARE @not_inserted_rows INT
        SELECT @total_insert_rows = COUNT(*) FROM inserted
        SELECT @not_inserted_rows = COUNT(*) FROM inserted WHERE NOT EXISTS
        (SELECT * FROM Lab9..Stores S WHERE S.location_id = inserted.location_id)
        INSERT INTO Lab9..Phone_Numbers
            SELECT inserted.location_id, inserted.phone_number FROM inserted
            WHERE EXISTS 
            (SELECT * FROM Lab9..Stores S WHERE S.location_id = inserted.location_id)
        PRINT 'Inserting ' + CAST((@total_insert_rows - @not_inserted_rows) AS VARCHAR)
                             + ' row(s)'
    END
GO
IF OBJECT_ID('dbo.PhoneNumUpdateTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.PhoneNumUpdateTrig
GO
CREATE TRIGGER PhoneNumUpdateTrig ON Lab9..Phone_Numbers
    INSTEAD OF UPDATE 
    AS BEGIN
        IF UPDATE(location_id) BEGIN
            IF EXISTS (SELECT location_id FROM inserted
            WHERE location_id NOT IN (SELECT location_id FROM Lab9..Stores))    
                            RAISERROR ('Trying to update to incorrect location id!', -1, -1)
            ELSE
                UPDATE Lab9..Phone_Numbers SET location_id = inserted.location_id 
                FROM inserted, deleted
                WHERE Phone_Numbers.phone_number = deleted.phone_number
                    AND deleted.phone_number_id = inserted.phone_number_id
        END
        IF UPDATE(phone_number) BEGIN
            IF EXISTS(SELECT TOP 1 inserted.phone_number FROM inserted
                        WHERE inserted.phone_number LIKE '8%')
                            PRINT 'Warning: View takes only numbers that start with 8'
            IF EXISTS (SELECT TOP 1 inserted.phone_number 
                        FROM Lab9..phone_numbers as p, inserted 
                        WHERE p.phone_number = inserted.phone_number)
                            RAISERROR ('Trying to update to already existing number!', -1, -1)
            ELSE
                UPDATE Lab9..Phone_Numbers SET phone_number = inserted.phone_number
                                    FROM inserted, deleted
                                    WHERE Phone_Numbers.phone_number = deleted.phone_number
                                        AND deleted.phone_number_id = inserted.phone_number_id
        END
    END
GO
IF OBJECT_ID('dbo.PhoneNumDeleteTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.PhoneNumDeleteTrig
GO
CREATE TRIGGER PhoneNumDeleteTrig ON Lab9..Phone_Numbers
    AFTER DELETE 
    AS BEGIN
        DECLARE @total_deleted_rows INT
        DECLARE @not_deleted_rows INT
        SELECT @total_deleted_rows = COUNT(*) FROM deleted
        SELECT @not_deleted_rows = COUNT(*) FROM deleted WHERE NOT EXISTS
        (SELECT * FROM Lab9..Stores S WHERE S.location_id = deleted.location_id)
        PRINT 'Deleted ' + CAST((@total_deleted_rows - @not_deleted_rows) AS VARCHAR)
                + ' row(s)'
    END
GO
INSERT Lab9..Stores (location_id, [location], capacity)
VALUES  ('100200300', 'Moscow, Pushkina str. 50', 1500),
        ('200300400', 'St. Petersburg, Matros str. 24', 1000),
        ('300400500', 'Ekaterinburg, Marxist str. 16', 560);
INSERT Lab9..Phone_Numbers (location_id, phone_number)
VALUES  ('100200300', '89005553535'),
        ('100200300', '88885553535'),
        ('111222333', '83923423545'),  -- не добавляется т.к. нет такого location_id
        ('200300400', '89502224343'),
        ('300400500', '79653004005'),
        ('300400500', '89653004085'),
        ('300400500', '79653004155');
GO
SELECT s.[location], p.phone_number
    FROM Lab9..Stores s INNER JOIN Lab9..Phone_numbers p
    ON s.location_id = p.location_id

GO
UPDATE Lab9..Phone_Numbers
SET phone_number = '1111111222' WHERE phone_number = '88885553535'

UPDATE Lab9..Phone_Numbers
SET phone_number = '8888888394' WHERE phone_number = '79653004005'

UPDATE Lab9..Phone_Numbers  -- вызовет предупреждение о начале не на 8
SET phone_number = '78005553535' WHERE phone_number = '89502224343'

UPDATE Lab9..Phone_Numbers  -- вызовет ошибку о попытке повторной записи идентичного номера
SET phone_number = '78005553535' WHERE phone_number = '1111111222'

UPDATE Lab9..Phone_Numbers
SET location_id = '200300400' WHERE phone_number = '89653004085'

UPDATE Lab9..Phone_Numbers
SET location_id = '222333444' WHERE phone_number = '8888888394' -- вызовет ошибку
GO
SELECT * FROM Phone_Numbers
UPDATE Lab9..Phone_Numbers
    SET location_id = '100200300'
    WHERE location_id IN ('200300400', '300400500', '400500600')
UPDATE Lab9..Phone_Numbers
    SET location_id = '200300400'
    WHERE phone_number IN ('1111111222', '8888888394')
GO
SELECT * FROM Phone_Numbers
SELECT s.[location], p.phone_number
    FROM Lab9..Stores s INNER JOIN Lab9..Phone_numbers p
    ON s.location_id = p.location_id
DELETE FROM Lab9..Phone_Numbers 
    WHERE phone_number IN ('1111111222', '79653004155', '123456')
GO
SELECT * FROM Lab9..Phone_Numbers

GO

-- 2) Для представления ЛР7 п.2 создать триггер на вставку, удаление и добавление,
-- обеспечивающие возможность выполнения операций с данными непосредственно 
-- через представление
IF OBJECT_ID('dbo.Phone_Numbers_To_Address', 'V') IS NOT NULL
DROP VIEW dbo.Phone_Numbers_To_Address
GO
CREATE VIEW dbo.Phone_Numbers_To_Address AS
    SELECT
        s.location_id, s.[location], p.phone_number
    FROM Lab9..Stores s INNER JOIN Lab9..Phone_numbers p
        ON s.location_id = p.location_Id
    WHERE phone_number LIKE '8%'
GO
CREATE TRIGGER ViewInsertTrig ON dbo.Phone_Numbers_To_Address
    INSTEAD OF INSERT
    AS BEGIN
        INSERT INTO Lab9..Phone_Numbers
            SELECT inserted.location_id, inserted.phone_number FROM inserted
            WHERE inserted.phone_number LIKE '8%'
    END
GO
CREATE TRIGGER ViewUpdateTrig ON dbo.Phone_Numbers_To_Address
    INSTEAD OF UPDATE
    AS BEGIN
        IF UPDATE(location_id) BEGIN
            UPDATE Lab9..Phone_Numbers
                SET Phone_Numbers.location_id = inserted.location_id
                FROM inserted, deleted
                WHERE Phone_Numbers.phone_number = deleted.phone_number
                    AND inserted.phone_number = deleted.phone_number
        END
        IF UPDATE(phone_number) BEGIN
            UPDATE Lab9..Phone_Numbers
                SET Phone_Numbers.phone_number = inserted.phone_number
                FROM inserted, deleted
                WHERE Phone_Numbers.phone_number = deleted.phone_number
                    AND inserted.location_id = deleted.location_Id
        END
    END
GO
CREATE TRIGGER ViewDeleteTrig ON dbo.Phone_Numbers_To_Address
    INSTEAD OF DELETE
    AS BEGIN
        DELETE FROM Lab9..Phone_Numbers
            WHERE EXISTS (SELECT * FROM deleted 
                WHERE Phone_Numbers.phone_number = deleted.phone_number)
    END
GO
INSERT dbo.Phone_Numbers_To_Address (location_id, phone_number)
VALUES ('200300400', '89508884343'),
       ('100200300', '88344534565'),
       ('200300400', '89507774343');
GO
INSERT dbo.Phone_Numbers_To_Address (location_id, phone_number)
VALUES ('300400500', '74564354005');        -- вызывается ошибка (номер не на 8)
GO
INSERT dbo.Phone_Numbers_To_Address (location_id, phone_number)
VALUES ('500600700', '74564354005');        -- вызывается ошибка (нет такого location_id)
GO
SELECT * FROM Lab9..Phone_Numbers
UPDATE dbo.Phone_Numbers_To_Address
    SET phone_number = '81111112222' WHERE phone_number = '89005553535'
UPDATE dbo.Phone_Numbers_To_Address
    SET phone_number = '15039544460'
    WHERE phone_number = '89653004005'     -- вызывается ошибка (номер не на 8)
UPDATE dbo.Phone_Numbers_To_Address
    SET location_id = '100200300'
    WHERE location_id IN ('200300400', '300400500', '400500600')
GO
SELECT * FROM Lab9..Phone_Numbers
GO
DELETE FROM dbo.Phone_Numbers_To_Address
    WHERE phone_number = '88344534565' 
DELETE FROM dbo.Phone_Numbers_To_Address
    WHERE  phone_number IN ('89508884343', '81111112222', '123456778')
GO
SELECT * FROM Lab9..Phone_Numbers
GO