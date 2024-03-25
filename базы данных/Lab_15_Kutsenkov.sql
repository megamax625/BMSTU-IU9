 -- 1) Создать в базах данных лр13 связанные таблицы
USE master
GO
IF DB_ID (N'Lab15_1') IS NOT NULL
DROP DATABASE Lab15_1
GO
-- создание таблиц
CREATE DATABASE Lab15_1
    ON ( NAME = Lab15_1_dat, FILENAME = "/var/opt/mssql/data/dbs/Lab15_1dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab15_1_log, FILENAME = "/var/opt/mssql/data/logs/Lab15_1log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
IF DB_ID (N'Lab15_2') IS NOT NULL
DROP DATABASE Lab15_2
GO
CREATE DATABASE Lab15_2
    ON ( NAME = Lab15_2_dat, FILENAME = "/var/opt/mssql/data/dbs/Lab15_2dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab15_2_log, FILENAME = "/var/opt/mssql/data/logs/Lab15_2log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
USE Lab15_1
IF OBJECT_ID('Lab15_1..Stores', 'U') IS NOT NULL
DROP TABLE Lab15_1..Stores
GO
CREATE TABLE Lab15_1..Stores (
    location_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [location] NVARCHAR(200) NOT NULL,
    work_hours TEXT NULL,
    capacity NUMERIC(8,2) NOT NULL
)
GO
USE Lab15_2
IF OBJECT_ID('Lab15_2..Phone_Numbers', 'U') IS NOT NULL
DROP TABLE Lab15_2..Phone_Numbers
GO
CREATE TABLE Lab15_2..Phone_Numbers (
    phone_number_id INT IDENTITY(112, 112) NOT NULL PRIMARY KEY,
    location_id INT NOT NULL,
    phone_number NVARCHAR(12) NOT NULL UNIQUE
)
GO

-- 2) Создать необходимые элементы бд, обеспечивающие работу с данными связанных таблиц
IF OBJECT_ID('dbo.StoresToPhoneNumbersView', 'V') IS NOT NULL
DROP TRIGGER dbo.StoresToPhoneNumbersView
GO
CREATE VIEW dbo.StoresToPhoneNumbersView AS
    SELECT S.location_id, S.[location], S.work_hours, S.capacity, P.phone_number 
    FROM Lab15_1..Stores AS S, Lab15_2..Phone_Numbers AS P
    WHERE S.location_id = P.location_id
GO
IF OBJECT_ID('dbo.StoresView', 'V') IS NOT NULL
DROP TRIGGER dbo.StoresView
GO
CREATE VIEW dbo.StoresView AS
    SELECT S.location_id, S.[location], S.work_hours, S.capacity
    FROM Lab15_1..Stores AS S
GO
IF OBJECT_ID('dbo.PhoneNumInsertTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.PhoneNumInsertTrig
GO
CREATE TRIGGER PhoneNumInsertTrig ON Lab15_2..Phone_Numbers 
    INSTEAD OF INSERT 
    AS BEGIN
        DECLARE @total_insert_rows INT
        DECLARE @not_inserted_rows INT
        SELECT @total_insert_rows = COUNT(*) FROM inserted
        SELECT @not_inserted_rows = COUNT(*) FROM inserted WHERE NOT EXISTS
            (SELECT * FROM Lab15_1..Stores S WHERE S.location_id = inserted.location_id)
        IF @not_inserted_rows > 0 BEGIN
            RAISERROR('Incorrect location id in phone insertion!', 1, 1)
            ROLLBACK
        END
        ELSE BEGIN
            INSERT INTO Lab15_2..Phone_Numbers
            SELECT inserted.location_id, inserted.phone_number FROM inserted
            PRINT 'Inserting ' + CAST(@total_insert_rows AS VARCHAR) + ' row(s) into Phone Numbers Table'
        END
    END
GO
IF OBJECT_ID('dbo.PhoneNumUpdateTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.PhoneNumUpdateTrig
GO
CREATE TRIGGER PhoneNumUpdateTrig ON Lab15_2..Phone_Numbers
    INSTEAD OF UPDATE 
    AS BEGIN
        IF UPDATE(phone_number_id) BEGIN
            RAISERROR('Should not update phone number id!', 1, 1)
            ROLLBACK
        END
        IF UPDATE(location_id) BEGIN
            IF EXISTS (SELECT location_id FROM inserted
            WHERE location_id NOT IN (SELECT location_id FROM Lab15_1..Stores)) BEGIN   
                            RAISERROR ('Trying to update to incorrect location id!', -1, -1)
                            ROLLBACK
                        END
            ELSE
                UPDATE Lab15_2..Phone_Numbers SET location_id = inserted.location_id 
                FROM inserted
                WHERE Phone_Numbers.phone_number_id = inserted.phone_number_id
        END
        IF UPDATE(phone_number) BEGIN
            UPDATE Lab15_2..Phone_Numbers SET phone_number = inserted.phone_number
                                FROM inserted, deleted
                                WHERE Phone_Numbers.phone_number_id = deleted.phone_number_id
        END
    END
GO
IF OBJECT_ID('dbo.PhoneNumDeleteTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.PhoneNumDeleteTrig
GO
CREATE TRIGGER PhoneNumDeleteTrig ON Lab15_2..Phone_Numbers
    AFTER DELETE 
    AS BEGIN
        DECLARE @total_deleted_rows INT
        SELECT @total_deleted_rows = COUNT(*) FROM deleted
        PRINT 'Deleted ' + CAST(@total_deleted_rows AS VARCHAR)
                + ' Phone Number(s)'
    END
GO
USE Lab15_1
IF OBJECT_ID('dbo.StoreInsertTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.StoreInsertTrig
GO
CREATE TRIGGER StoreInsertTrig ON Lab15_1..Stores
    INSTEAD OF INSERT 
    AS BEGIN
        DECLARE @oldStoresSize INT
        DECLARE @newStoresSize INT
        SELECT @oldStoresSize = COUNT(*) FROM Lab15_1..Stores
        INSERT INTO Lab15_1..Stores 
            SELECT i.[location], i.work_hours, i.capacity FROM inserted AS i
        SELECT @newStoresSize = COUNT(*) FROM Lab15_1..Stores
        IF @newStoresSize > @oldStoresSize
            PRINT 'Inserted ' + CAST((@newStoresSize - @oldStoresSize) AS VARCHAR)
                             + ' row(s) into Stores Table'
    END
GO
IF OBJECT_ID('dbo.StoreUpdateTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.StoreUpdateTrig
GO
CREATE TRIGGER StoreUpdateTrig ON Lab15_1..Stores
    INSTEAD OF UPDATE 
    AS BEGIN
        IF UPDATE(location_id) BEGIN
            RAISERROR('Should not update Store id!!', 1, 1)
            ROLLBACK
        END
        ELSE UPDATE Lab15_1..Stores SET [location] = i.[location], work_hours = i.work_hours,
            capacity = i.capacity FROM inserted as i WHERE i.location_id = Stores.location_id
    END
GO
IF OBJECT_ID('dbo.StoreDeleteTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.StoreDeleteTrig
GO
CREATE TRIGGER StoreDeleteTrig ON Lab15_1..Stores
    INSTEAD OF DELETE 
    AS BEGIN
        DECLARE @deletedStoresNum INT
        SET @deletedStoresNum = (SELECT COUNT(*) from deleted, Lab15_1..Stores
            WHERE deleted.location_id = Stores.location_id)
        PRINT 'Deleting ' + CAST(@deletedStoresNum AS VARCHAR) + ' Stores'
        DELETE FROM Lab15_2..Phone_Numbers WHERE EXISTS (SELECT * from deleted
            WHERE deleted.location_id = Phone_Numbers.location_id)
        DELETE FROM Lab15_1..Stores WHERE EXISTS (SELECT * from deleted 
            WHERE deleted.location_id = Stores.location_id)
    END
GO

-- проверка
USE Lab15_2
INSERT Lab15_1..Stores (location, capacity)
VALUES ('Moscow, Pushkina str. 50', 1500),
    ('St. Petersburg, Matros str. 24', 1000),
    ('Ekaterinburg, Marxist str. 16', 560),
    ('Chelyabinsk, Stahl str. 5', 750)
INSERT Lab15_2..Phone_Numbers (location_id, phone_number)
VALUES (1, '88005553535'),
    (2, '89502224343'),
    (3, '79653004005'),
    (3, '79653004155'),
    (2, '83949534959'),
    (4, '13456678543')
GO
INSERT Lab15_2..Phone_Numbers (location_id, phone_number)
VALUES (100, '21345'),
    (200, '21345234')
GO
SELECT * FROM dbo.StoresToPhoneNumbersView

UPDATE Lab15_1..Stores
SET [location] = 'Moscow, Baumana str. 2', capacity = 2000, work_hours = '8:00 - 22:00' 
    WHERE [location] = 'Moscow, Pushkina str. 50';
UPDATE Lab15_1..Stores
SET capacity = 1000, work_hours = '8:00 - 21:00' 
    WHERE [location] IN ('St. Petersburg, Matros str. 24', 'Ekaterinburg, Marxist str. 16')

SELECT * FROM dbo.StoresToPhoneNumbersView
GO
UPDATE Lab15_2..Phone_Numbers SET phone_number_id = 100 WHERE phone_number_id = 448
GO
UPDATE Lab15_2..Phone_Numbers
    SET phone_number = '88888888888', location_id = 1 WHERE phone_number = '79653004155'
UPDATE Lab15_2..Phone_Numbers
SET location_id = 100 WHERE phone_number = '88888888888' -- не выполняется с ошибкой
GO
SELECT * FROM Phone_Numbers WHERE phone_number = '88888888888'
UPDATE Lab15_1..Stores SET location_id = 100, capacity = 100000 WHERE location_id = 1 -- не вып. с ошибкой
GO
DELETE FROM Lab15_1..Stores WHERE [location] IN ('St. Petersburg, Matros str. 24', 'Chelyabinsk, Stahl str. 5')
DELETE FROM Lab15_2..Phone_Numbers WHERE phone_number = '79653004005'

SELECT * FROM dbo.StoresView
SELECT * FROM dbo.StoresToPhoneNumbersView
SELECT * FROM Lab15_1..Stores
SELECT * FROM Lab15_2..Phone_Numbers