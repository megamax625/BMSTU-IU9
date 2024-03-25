-- 1) Создать две базы данных на одном экземпляре СУБД
USE master
GO
IF DB_ID (N'Lab13_1') IS NOT NULL
DROP DATABASE Lab13_1
GO
-- Create a new database
CREATE DATABASE Lab13_1
    ON ( NAME = Lab13_1_dat, FILENAME = "/var/opt/mssql/data/dbs/Lab13_1dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab13_1_log, FILENAME = "/var/opt/mssql/data/logs/Lab13_1log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
IF DB_ID (N'Lab13_2') IS NOT NULL
DROP DATABASE Lab13_2
GO
-- Create a new database
CREATE DATABASE Lab13_2
    ON ( NAME = Lab13_2_dat, FILENAME = "/var/opt/mssql/data/dbs/Lab13_2dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab13_2_log, FILENAME = "/var/opt/mssql/data/logs/Lab13_2log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
-- 2) Создать в базах данных п.1 горизонтально фрагментированные таблицы
USE Lab13_1
IF OBJECT_ID('Lab13_1..Goods_4', 'U') IS NOT NULL
DROP TABLE Lab13_1..Goods_4
GO
CREATE TABLE Lab13_1..Goods_4 (
    Goods_id INT NOT NULL PRIMARY KEY
        CHECK (Goods_id BETWEEN 1 AND 4),
    Batch_number INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Available BIT NOT NULL DEFAULT 0,
    Current_price MONEY NOT NULL
)
GO
USE Lab13_2
IF OBJECT_ID('Lab13_2..Goods_8', 'U') IS NOT NULL
DROP TABLE Lab13_2..Goods_8
GO
CREATE TABLE Lab13_2..Goods_8 (
    Goods_id INT NOT NULL PRIMARY KEY
        CHECK (Goods_id BETWEEN 5 AND 8),
    Batch_number INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Available BIT NOT NULL DEFAULT 0,
    Current_price MONEY NOT NULL
)
GO
-- 3) Создать секционированные представлнения, обеспечаивающие работу с данными таблиц
IF OBJECT_ID('Goods', 'V') IS NOT NULL
DROP VIEW Goods
GO
CREATE VIEW Goods AS
    SELECT * FROM Lab13_1.dbo.Goods_4
    UNION ALL
    SELECT * FROM Lab13_2.dbo.Goods_8
GO
USE Lab13_1
IF OBJECT_ID('Goods', 'V') IS NOT NULL
DROP VIEW Goods
GO
CREATE VIEW Goods AS
    SELECT * FROM Lab13_1.dbo.Goods_4
    UNION ALL
    SELECT * FROM Lab13_2.dbo.Goods_8
GO
-- тестирование
INSERT INTO Goods VALUES
    (1, 1100, 'Parrot food', 1, 900),
    (2, 1200, 'Cat food', 1, 750),
    (3, 1300, 'Dog food', 1, 800),
    (4, 1400, 'Hamster food', 1, 500),
    (5, 1500, 'Parrot toy', 1, 500),
    (6, 1600, 'Cat toy', 1, 650),
    (7, 1700, 'Dog toy', 1, 550),
    (8, 1800, 'Hamster wheel', 1, 300)
    --(9, 'Dog Bone', 1, 250)   -- естественно, вызывает ошибку
GO
--SELECT * FROM Goods
SELECT * FROM Lab13_1.dbo.Goods_4
SELECT * FROM Lab13_2.dbo.Goods_8
GO

DELETE FROM Goods WHERE Goods_id IN (1, 3, 6, 8)
--SELECT * FROM Goods
SELECT * FROM Lab13_1.dbo.Goods_4
SELECT * FROM Lab13_2.dbo.Goods_8
GO

UPDATE Goods SET Goods_id = 1 WHERE Goods_id = 7
UPDATE Goods SET Goods_id = 8 Where Goods_id = 4
UPDATE Goods SET Goods_id = 7 WHERE Goods_id = 5
SELECT * FROM Goods
SELECT * FROM Lab13_1.dbo.Goods_4
SELECT * FROM Lab13_2.dbo.Goods_8