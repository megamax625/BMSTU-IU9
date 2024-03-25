-- 1) Создать в базах данных лр13 таблицы, содержащие вертикально фрагментированные данные
USE master
GO
IF DB_ID (N'Lab14_1') IS NOT NULL
DROP DATABASE Lab14_1
GO
-- Create a new database
CREATE DATABASE Lab14_1
    ON ( NAME = Lab14_1_dat, FILENAME = "/var/opt/mssql/data/dbs/Lab14_1dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab14_1_log, FILENAME = "/var/opt/mssql/data/logs/Lab14_1log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
IF DB_ID (N'Lab14_2') IS NOT NULL
DROP DATABASE Lab14_2
GO
-- Create a new database
CREATE DATABASE Lab14_2
    ON ( NAME = Lab14_2_dat, FILENAME = "/var/opt/mssql/data/dbs/Lab14_2dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab14_2_log, FILENAME = "/var/opt/mssql/data/logs/Lab14_2log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
-- создание таблиц
USE Lab14_1
IF OBJECT_ID('Lab14_1..Goods', 'U') IS NOT NULL
DROP TABLE Lab14_1..Goods
GO
CREATE TABLE Lab14_1..Goods (
    Goods_id INT NOT NULL PRIMARY KEY,
    Batch_number INT UNIQUE NOT NULL,
    Title NVARCHAR(100) NOT NULL,
)
GO
USE Lab14_2
IF OBJECT_ID('Lab14_2..Goods', 'U') IS NOT NULL
DROP TABLE Lab14_2..Goods
GO
CREATE TABLE Lab14_2..Goods (
    Goods_id INT NOT NULL PRIMARY KEY,
    Available BIT NOT NULL DEFAULT 0,
    Current_price MONEY NOT NULL
)
GO
-- 2) Создать необходимые элементы базы данных (представления, триггеры), обеспечивающие работу с данными
-- вертикально фрагментированных таблиц
USE Lab14_1
IF OBJECT_ID('GoodsView', 'V') IS NOT NULL
DROP VIEW GoodsView
GO
CREATE VIEW GoodsView AS
    SELECT one.Goods_id, one.Batch_number, one.Title, two.Available, two.Current_price
    FROM Lab14_1.dbo.Goods AS one, Lab14_2.dbo.Goods AS two
    WHERE one.Goods_id = two.Goods_id
GO
IF OBJECT_ID('dbo.GoodsInsertTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.GoodsInsertTrig
GO
CREATE TRIGGER GoodsInsertTrig ON GoodsView
    INSTEAD OF INSERT
    AS BEGIN
        INSERT INTO Lab14_1.dbo.Goods(Goods_id, Batch_number, Title)
            SELECT Goods_id, Batch_number, Title FROM inserted
        INSERT INTO Lab14_2.dbo.Goods(Goods_id, Available, Current_price)
            SELECT Goods_id, Available, Current_price FROM inserted
    END
GO
IF OBJECT_ID('dbo.GoodsUpdateTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.GoodsUpdateTrig
GO
CREATE TRIGGER GoodsUpdateTrig ON GoodsView
    INSTEAD OF UPDATE
    AS BEGIN
        UPDATE Lab14_1.dbo.Goods SET Title = inserted.Title,
                Batch_number = inserted.Batch_number FROM inserted
            WHERE Goods.Goods_id = inserted.Goods_id
        UPDATE Lab14_2.dbo.Goods SET Current_price = inserted.Current_price FROM inserted
            WHERE Goods.Goods_id = inserted.Goods_id
    END
GO
IF OBJECT_ID('dbo.GoodsDeleteTrig', 'T') IS NOT NULL
DROP TRIGGER dbo.GoodsDeleteTrig
GO
CREATE TRIGGER GoodsDeleteTrig ON GoodsView
    INSTEAD OF DELETE
    AS BEGIN
        UPDATE Lab14_2.dbo.Goods SET Available = 0 FROM deleted
            WHERE Goods.Goods_id = deleted.Goods_id
    END
GO

-- тестирование
INSERT INTO GoodsView(Goods_id, Batch_number, Title, Available, Current_price) VALUES
    (1, 1101, 'Parrot food', 1, 901),
    (2, 1200, 'Cat food', 1, 750),
    (3, 1300, 'Dog food', 1, 800),
    (4, 1400, 'Hamster food', 1, 500),
    (5, 1500, 'Parrot toy', 1, 500),
    (6, 1600, 'Cat toy', 1, 650),
    (7, 1700, 'Dog toy', 1, 550),
    (8, 1800, 'Hamster wheel', 1, 300),
    (9, 1900, 'Dog Bone', 1, 250)
GO
INSERT GoodsView(Goods_id, Batch_number, Title, Available, Current_price) VALUES
    (10, 1500, 'Error1', 1, 999) -- не добавляется с сообщением об ошибке
GO
INSERT GoodsView(Goods_id, Batch_number, Title, Available, Current_price) VALUES
    (10, 1500, 'Error2', 1, 100) -- не добавляется с сообщением об ошибке
GO
INSERT GoodsView(Goods_id, Batch_number, Title, Available, Current_price) VALUES
    (1, 1500, 'Error3', 1, 100) -- не добавляется с сообщением об ошибке
GO
SELECT * FROM GoodsView
GO
UPDATE GoodsView SET Batch_number = 2200 WHERE Batch_number = 1200 --
UPDATE GoodsView SET Batch_number = 1600 WHERE Batch_number = 1800 -- не выполняются с сообщением об ошибке
GO
UPDATE GoodsView SET Title = 'Bird toy' WHERE Title = 'Parrot toy'
UPDATE GoodsView SET Title = 'Bird food' WHERE Title = 'Parrot food'
SELECT * FROM GoodsView
UPDATE GoodsView SET Current_price = Current_price + 150 WHERE Batch_number < 2000
SELECT Batch_number, Current_price FROM GoodsView
GO
DELETE FROM GoodsVIEW WHERE Batch_number BETWEEN 1500 AND 1800
SELECT * FROM GoodsView
SELECT * FROM Lab14_1.dbo.Goods
SELECT * FROM Lab14_2.dbo.Goods