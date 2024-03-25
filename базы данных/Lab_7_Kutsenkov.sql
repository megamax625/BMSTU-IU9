USE master
GO
IF DB_ID (N'Lab7') IS NOT NULL
DROP DATABASE Lab7
GO
-- Create a new database
CREATE DATABASE Lab7
    ON ( NAME = Lab7_dat, FILENAME = "/var/opt/mssql/data/dbs/lab7dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab7_log, FILENAME = "/var/opt/mssql/data/logs/lab7log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
USE Lab7
-- 1) Create View based on a table from Lab6
IF OBJECT_ID('Lab7..Pet', 'U') IS NOT NULL
DROP TABLE Lab7..Pet
GO
CREATE TABLE Lab7..Pet (
    vet_certificate_number INT PRIMARY KEY,
    genus NVARCHAR(30) NOT NULL,
    date_of_birth DATETIME NOT NULL,
    price MONEY NOT NULL
)
GO
DROP SEQUENCE IF EXISTS CountBy1
GO
CREATE SEQUENCE CountBy1
    START WITH 100000000
    INCREMENT BY 1;
GO
INSERT Lab7..Pet (vet_certificate_number, genus, date_of_birth, price)
VALUES  (NEXT VALUE FOR CountBy1, 'dog', GETDATE(), 9000),
        (NEXT VALUE FOR CountBy1, 'cat', GETDATE(), 4500),
        (NEXT VALUE FOR CountBy1, 'parrot', GETDATE(), 27000),
        (NEXT VALUE FOR CountBy1, 'cat', GETDATE(), 10000),
        (NEXT VALUE FOR CountBy1, 'hamster', GETDATE(), 3000),
        (NEXT VALUE FOR CountBy1, 'parrot', GETDATE(), 12000);
GO
IF OBJECT_ID('Expensive_Pets_Qry', 'V') IS NOT NULL
DROP VIEW Expensive_Pets_Qry
GO
CREATE VIEW Expensive_Pets_Qry AS
    SELECT
        p.genus, p.date_of_birth, p.price
    FROM Lab7..Pet as p
    WHERE p.price >= 10000
    WITH CHECK OPTION
GO
UPDATE Expensive_Pets_Qry
    -- SET price = 9000     Error raised from WITH CHECK OPTION
    SET price = 11500
    WHERE genus = 'cat'
DELETE FROM Expensive_Pets_Qry
    WHERE genus = 'cat' OR genus = 'hamster'
GO

SELECT p.genus, p.price
FROM Expensive_Pets_Qry AS p
GO
DROP VIEW Expensive_Pets_Qry
-- 2) Create View based on both linked tables from Lab6
IF OBJECT_ID('Lab7..Stores', 'U') IS NOT NULL
DROP TABLE Lab7..Stores
GO
CREATE TABLE Lab7..Stores (
    location_id INT NOT NULL PRIMARY KEY,
    location NVARCHAR(200) NOT NULL,
    work_hours TEXT  NULL,
    capacity NUMERIC(8,2) NOT NULL
)
IF OBJECT_ID('Lab7..Phone_Numbers', 'U') IS NOT NULL
DROP TABLE Lab7..Phone_Numbers
GO
CREATE TABLE Lab7..Phone_Numbers (
    phone_number_id INT NOT NULL PRIMARY KEY,
    location_id INT FOREIGN KEY 
    REFERENCES Lab7..Stores(location_id) ON DELETE CASCADE ON UPDATE CASCADE
    CONSTRAINT DF_Location_Id DEFAULT 'Underworld',
    phone_number NVARCHAR(12) NOT NULL
)
INSERT Lab7..Stores (location_id, [location], capacity)
VALUES  ('100200300', 'Moscow, Pushkina str. 50', 1500),
        ('200300400', 'St. Petersburg, Matros str. 24', 1000),
        ('300400500', 'Ekaterinburg, Marxist str. 16', 560);
INSERT Lab7..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES  (112, '100200300', '88005553535'),
        (200, '100200300', '88885553535'),
        (224, '200300400', '89502224343'),
        (336, '300400500', '79653004005'),
        (400, '300400500', '89653004005'),
        (448, '300400500', '79653004155');
GO
IF OBJECT_ID('Phone_Numbers_To_Address', 'V') IS NOT NULL
DROP VIEW Phone_Numbers_To_Address
GO
CREATE VIEW Phone_Numbers_To_Address AS
    SELECT
        s.location_id, s.[location], p.phone_number
    FROM Lab7..Stores s INNER JOIN Lab7..Phone_numbers p
        ON s.location_id = p.location_Id
    WHERE phone_number LIKE '8%'
    WITH CHECK OPTION
GO
UPDATE Phone_Numbers_To_Address
    SET location_id = '100200333'
    WHERE location_id = '100200300';
/*UPDATE Phone_Numbers_To_Address
    SET phone_number = '15039544460'
    WHERE location_id = '200300400'     Error raised from WITH CHECK OPTION*/
GO
SELECT * FROM Phone_Numbers_To_Address
GO
-- 3) Create Index for a table from Lab6 including non-key fields
IF OBJECT_ID('Lab7..Goods', 'U') IS NOT NULL
DROP TABLE Lab7..Goods
GO
CREATE TABLE Lab7..Goods (
    goods_id INT IDENTITY(15000, 5) NOT NULL PRIMARY KEY,
    article_number INT NOT NULL,
    batch_number INT NOT NULL,
    title NVARCHAR(100) NOT NULL,
    "description" NVARCHAR(100) NULL,
    expiration_date DATETIME NOT NULL,
    current_price MONEY
        CONSTRAINT CHK_Goods_Price CHECK (current_price > 30 AND current_price <25000)
)
INSERT Lab7..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (130500, 2050, 'Parrot toy', '2020-10-12', 350),
    (130500, 2150, 'Parrot toy', '2021-10-12', 500),
    (130500, 2550, 'Parrot toy', '2023-10-12', 750),
    (150500, 2150, 'Parrot Cage', '2018-10-10', 7000),
    (150500, 2170, 'Parrot Cage', '2030-10-10', 8700);
GO
CREATE NONCLUSTERED INDEX IX_Goods
    ON Lab7..Goods (expiration_date)
    INCLUDE (article_number, batch_number)
GO
sp_helpindex N'dbo.Goods'
GO
SELECT g.article_number, g.batch_number
    FROM Lab7..Goods AS g
    WHERE expiration_date < GETDATE()
GO
-- 4) Create Indexed View
IF OBJECT_ID('Lab7..Employees', 'U') IS NOT NULL
DROP TABLE Lab7..Employees
GO
CREATE TABLE Lab7..Employees (
    employee_id INT IDENTITY(1000, 1) NOT NULL PRIMARY KEY,
    "name" NVARCHAR(30) NOT NULL,
    surname NVARCHAR(30) NOT NULL,
    patronymic NVARCHAR(30) NOT NULL,
    position INT NOT NULL
);
GO
INSERT Lab7..Employees ("name", surname, patronymic, position)
VALUES  ('Mike', 'Smith', 'Patrickovich', 2),
        ('Karen', 'Smith', 'Patrickovna', 7),
        ('John', 'Shikshin', 'Vladimirovich', 8),
        ('George', 'Fried', 'Hermanovich', 6);
GO
IF OBJECT_ID('Employees_NS_P', 'V') IS NOT NULL
DROP VIEW Employees_NS_P
GO
CREATE VIEW Employees_NS_P WITH SCHEMABINDING AS
    SELECT employee_id, [name], surname, position
    FROM dbo.Employees
    WHERE position BETWEEN 4 AND 8
GO
SELECT [name], surname, [position] FROM Employees_NS_P
GO
CREATE UNIQUE CLUSTERED INDEX IV_Employees ON Employees_NS_P(employee_id)
GO
sp_helpindex N'Employees_NS_P'