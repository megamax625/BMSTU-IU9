USE master
GO
IF DB_ID (N'Lab6') IS NOT NULL
DROP DATABASE Lab6
GO
-- 1) Create a new database
CREATE DATABASE Lab6
    ON ( NAME = Lab6_dat, FILENAME = "/var/opt/mssql/data/dbs/lab6dat.mdf",
        SIZE = 20 MB, MAXSIZE = UNLIMITED, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab6_log, FILENAME = "/var/opt/mssql/data/logs/lab6log.ldf",
        SIZE = 10 MB, MAXSIZE = 30 MB, FILEGROWTH = 10 MB)
GO
-- 1) Create table with autoincremented primary key
IF OBJECT_ID('Lab6..Employees', 'U') IS NOT NULL
DROP TABLE Lab6..Employees
GO
CREATE TABLE Lab6..Employees (
    employee_id INT IDENTITY(1000, 1) NOT NULL PRIMARY KEY,
    "name" NVARCHAR(30) NOT NULL,
    surname NVARCHAR(30) NOT NULL,
    patronymic NVARCHAR(30) NOT NULL,
    position INT NOT NULL
);
GO
INSERT Lab6..Employees ("name", surname, patronymic, position)
VALUES ('Mike', 'Smith', 'Patrickovich', 2);
INSERT Lab6..Employees 
    ("name", surname, patronymic, position)
VALUES 
    ('Karen', 'Smith', 'Patrickovna', 7);
INSERT Lab6..Employees 
    ("name", surname, patronymic, position)
VALUES 
    ('John', 'Shikshin', 'Vladimirovich', 8);
SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]
GO
INSERT Lab6..Employees 
    ("name", surname, patronymic, position)
VALUES
    ('George', 'Fried', 'Hermanovich', 6);
SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]
-- 2) Add fields with CHECK, DEFAULT constraints, use builtit calc funcs
IF OBJECT_ID('Lab6..Consumers', 'U') IS NOT NULL
DROP TABLE Lab6..Consumers
GO
CREATE TABLE Lab6..Consumers (
    consumer_id INT NOT NULL PRIMARY KEY,
    e_mail NVARCHAR(320) NOT NULL,
    "name" NVARCHAR(30) NOT NULL,
    surname NVARCHAR(30) NOT NULL,
    phone_number NVARCHAR(12) NULL,
    bonuses INT 
        CONSTRAINT DF_Base_Bonuses DEFAULT 0,
)
IF OBJECT_ID('Lab6..Goods', 'U') IS NOT NULL
DROP TABLE Lab6..Goods
GO
CREATE TABLE Lab6..Goods (
    goods_id INT IDENTITY(15000, 5) NOT NULL PRIMARY KEY,
    article_number INT NOT NULL,
    batch_number INT NOT NULL,
    title NVARCHAR(100) NOT NULL,
    "description" NVARCHAR(100) NULL,
    expiration_date DATETIME NOT NULL
        CONSTRAINT CHK_Goods_Exp_Date CHECK 
        (expiration_date > CONVERT(DATETIME, DATEADD(day, -7, GETDATE()))),
    current_price MONEY
        CONSTRAINT CHK_Goods_Price CHECK (current_price > 30 AND current_price <25000)
)
GO
/*INSERT Lab6..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (100200, 150, 'Dog food', '2007-11-11', 1500)
INSERT Lab6..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (100500, 2000, 'Cat food', '2022-12-12', -3000)*/
INSERT Lab6..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (130500, 2050, 'Parrot toy', '2025-10-12', 350);
INSERT Lab6..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (130500, 2150, 'Parrot toy', '2027-10-12', 500);
INSERT Lab6..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (130500, 2550, 'Parrot toy', '2025-10-12', 750);
INSERT Lab6..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (150500, 2150, 'Parrot Cage', '2030-10-10', 7000);
INSERT Lab6..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (150500, 2170, 'Parrot Cage', '2030-10-10', 8700);
SELECT
     g.article_number,
     max(g.current_price) - min(g.current_price) as difference,
     min(g.current_price) as min_current_price,
     max(g.current_price) as max_current_price
FROM
     Lab6..Goods as g
GROUP BY
     g.article_number;
GO
-- 3) Create Table with Primary Key based on GUID
IF OBJECT_ID('Lab6..Orders', 'U') IS NOT NULL
DROP TABLE Lab6..Orders
GO
DECLARE @id UNIQUEIDENTIFIER
SET @id = NEWID();
SELECT @id AS GUID
CREATE TABLE Lab6..Orders (
    order_id UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL PRIMARY KEY
        CONSTRAINT DF_Order_rowguid DEFAULT NEWID(),
    trade_date DATETIME NOT NULL
        CONSTRAINT DF_Trade_Date DEFAULT GETDATE(),
    receipt_number INT NOT NULL,
    total_price MONEY NOT NULL
        CONSTRAINT CHK_Total_Price CHECK (total_price > 30),
    payment_method INT NOT NULL
        CONSTRAINT DF_Payment_Method DEFAULT 1
)
GO
INSERT Lab6..Orders (receipt_number, total_price)
VALUES (1300, 500);
INSERT Lab6..Orders (receipt_number, total_price)
VALUES (1800, 900);
INSERT Lab6..Orders (receipt_number, trade_date, total_price)
VALUES (1500, '2021-08-08', 3000);
INSERT Lab6..Orders (receipt_number, trade_date, total_price)
VALUES (1700, '2021-08-08', 1500);
SELECT
    o.trade_date as trade_date,
    AVG(total_price) as average_price,
    SUM(total_price) as price_sum
FROM 
    Lab6..Orders as o
GROUP BY
    o.trade_date;
-- 4) Create Table with Primary Key based on a sequence
IF OBJECT_ID('Lab6..Pet', 'U') IS NOT NULL
DROP TABLE Lab6..Pet
GO
CREATE TABLE Lab6..Pet (
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
INSERT Lab6..Pet (vet_certificate_number, genus, date_of_birth, price)
VALUES (NEXT VALUE FOR CountBy1, 'dog', GETDATE(), 9000);
INSERT Lab6..Pet (vet_certificate_number, genus, date_of_birth, price)
VALUES (NEXT VALUE FOR CountBy1, 'cat', GETDATE(), 4500);
INSERT Lab6..Pet (vet_certificate_number, genus, date_of_birth, price)
VALUES (NEXT VALUE FOR CountBy1, 'parrot', GETDATE(), 12000);
SELECT NEXT VALUE FOR CountBy1
GO

-- 5) Create two linked tables and check

/*  NO ACTION
IF OBJECT_ID('Lab6..Store', 'U') IS NOT NULL
DROP TABLE Lab6..Store
GO
CREATE TABLE Lab6..Store (
    location_id INT NOT NULL PRIMARY KEY,
    location NVARCHAR(200) NOT NULL,
    work_hours TEXT  NULL,
    capacity NUMERIC(8,2) NOT NULL
)
IF OBJECT_ID('Lab6..Phone_Numbers', 'U') IS NOT NULL
DROP TABLE Lab6..Phone_Numbers
GO
CREATE TABLE Lab6..Phone_Numbers (
    phone_number_id INT NOT NULL PRIMARY KEY,
    location_id INT FOREIGN KEY 
    REFERENCES Lab6..Store(location_id) ON DELETE NO ACTION ON UPDATE NO ACTION
    CONSTRAINT DF_Location_Id DEFAULT 'Underworld',
    phone_number NVARCHAR(12) NOT NULL
)
INSERT Lab6..Store (location_id, location, capacity)
VALUES ('100200300', 'Moscow, Pushkina str. 50', 1500);
INSERT Lab6..Store (location_id, location, capacity)
VALUES ('200300400', 'St. Petersburg, Matros str. 24', 1000);
INSERT Lab6..Store (location_id, location, capacity)
VALUES ('300400500', 'Ekaterinburg, Marxist str. 16', 560);
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (112, '100200300', '88005553535');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (224, '200300400', '89502224343');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (336, '300400500', '79653004005');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (448, '300400500', '79653004155');
GO
UPDATE Lab6..Store
SET location_id = '10' WHERE location = 'Moscow, Pushkina str. 50';
UPDATE Lab6..Store
SET location_id = '20' WHERE location = 'St. Petersburg, Matros str. 24';
UPDATE Lab6..Store
SET location_id = '30' WHERE location = 'Ekaterinburg, Marxist str. 16';
SELECT
    s.location_id,
    s.location
FROM
    Lab6..Store as s
GROUP BY
    s.location_id, s.location;
SELECT
    p.phone_number_id,
    p.location_id
FROM
    Lab6..Phone_Numbers as p
GROUP BY
    p.phone_number_id, p.location_id;   */



IF OBJECT_ID('Lab6..Store', 'U') IS NOT NULL
DROP TABLE Lab6..Store
GO
CREATE TABLE Lab6..Store (
    location_id INT NOT NULL PRIMARY KEY,
    location NVARCHAR(200) NOT NULL,
    work_hours TEXT  NULL,
    capacity NUMERIC(8,2) NOT NULL
)
IF OBJECT_ID('Lab6..Phone_Numbers', 'U') IS NOT NULL
DROP TABLE Lab6..Phone_Numbers
GO
CREATE TABLE Lab6..Phone_Numbers (
    phone_number_id INT NOT NULL PRIMARY KEY,
    location_id INT FOREIGN KEY 
    REFERENCES Lab6..Store(location_id) ON DELETE CASCADE ON UPDATE CASCADE
    CONSTRAINT DF_Location_Id DEFAULT 'Underworld',
    phone_number NVARCHAR(12) NOT NULL
)
INSERT Lab6..Store (location_id, location, capacity)
VALUES ('100200300', 'Moscow, Pushkina str. 50', 1500);
INSERT Lab6..Store (location_id, location, capacity)
VALUES ('200300400', 'St. Petersburg, Matros str. 24', 1000);
INSERT Lab6..Store (location_id, location, capacity)
VALUES ('300400500', 'Ekaterinburg, Marxist str. 16', 560);
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (112, '100200300', '88005553535');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (224, '200300400', '89502224343');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (336, '300400500', '79653004005');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (448, '300400500', '79653004155');
GO
UPDATE Lab6..Store
SET location_id = '10' WHERE location = 'Moscow, Pushkina str. 50';
UPDATE Lab6..Store
SET location_id = '20' WHERE location = 'St. Petersburg, Matros str. 24';
UPDATE Lab6..Store
SET location_id = '30' WHERE location = 'Ekaterinburg, Marxist str. 16';
SELECT
    s.location_id,
    s.location
FROM
    Lab6..Store as s
GROUP BY
    s.location_id, s.location;
SELECT
    p.phone_number_id,
    p.location_id
FROM
    Lab6..Phone_Numbers as p
GROUP BY
    p.phone_number_id, p.location_id;
GO
DELETE FROM Lab6..Store WHERE location = 'St. Petersburg, Matros str. 24';
SELECT
    s.location_id,
    s.location
FROM
    Lab6..Store as s
GROUP BY
    s.location_id, s.location;
SELECT
    p.phone_number_id,
    p.location_id
FROM
    Lab6..Phone_Numbers as p
GROUP BY
    p.phone_number_id, p.location_id;



/*  SET NULL
IF OBJECT_ID('Lab6..Store', 'U') IS NOT NULL
DROP TABLE Lab6..Store
GO
CREATE TABLE Lab6..Store (
    location_id INT NOT NULL PRIMARY KEY,
    location NVARCHAR(200) NOT NULL,
    work_hours TEXT  NULL,
    capacity NUMERIC(8,2) NOT NULL
)
IF OBJECT_ID('Lab6..Phone_Numbers', 'U') IS NOT NULL
DROP TABLE Lab6..Phone_Numbers
GO
CREATE TABLE Lab6..Phone_Numbers (
    phone_number_id INT NOT NULL PRIMARY KEY,
    location_id INT FOREIGN KEY 
    REFERENCES Lab6..Store(location_id) ON DELETE SET NULL ON UPDATE SET NULL
    CONSTRAINT DF_Location_Id DEFAULT 'Underworld',
    phone_number NVARCHAR(12) NOT NULL
)
INSERT Lab6..Store (location_id, location, capacity)
VALUES ('100200300', 'Moscow, Pushkina str. 50', 1500);
INSERT Lab6..Store (location_id, location, capacity)
VALUES ('200300400', 'St. Petersburg, Matros str. 24', 1000);
INSERT Lab6..Store (location_id, location, capacity)
VALUES ('300400500', 'Ekaterinburg, Marxist str. 16', 560);
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (112, '100200300', '88005553535');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (224, '200300400', '89502224343');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (336, '300400500', '79653004005');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (448, '300400500', '79653004155');
GO
UPDATE Lab6..Store
SET location_id = '10' WHERE location = 'Moscow, Pushkina str. 50';
UPDATE Lab6..Store
SET location_id = '20' WHERE location = 'St. Petersburg, Matros str. 24';
UPDATE Lab6..Store
SET location_id = '30' WHERE location = 'Ekaterinburg, Marxist str. 16';
SELECT
    s.location_id,
    s.location
FROM
    Lab6..Store as s
GROUP BY
    s.location_id, s.location;
SELECT
    p.phone_number_id,
    p.location_id
FROM
    Lab6..Phone_Numbers as p
GROUP BY
    p.phone_number_id, p.location_id;   */


/* SET DEFAULT
IF OBJECT_ID('Lab6..Stores', 'U') IS NOT NULL
DROP TABLE Lab6..Stores
GO
CREATE TABLE Lab6..Stores (
    location_id INT NOT NULL PRIMARY KEY
    CONSTRAINT DF_Store_Location_ID DEFAULT 100,
    location NVARCHAR(200) NOT NULL,
    work_hours TEXT  NULL,
    capacity NUMERIC(8,2) NOT NULL
)
IF OBJECT_ID('Lab6..Phone_Numbers', 'U') IS NOT NULL
DROP TABLE Lab6..Phone_Numbers
GO
CREATE TABLE Lab6..Phone_Numbers (
    phone_number_id INT NOT NULL PRIMARY KEY,
    location_id INT DEFAULT 1 CONSTRAINT DK_Phone_Location_Id
    FOREIGN KEY REFERENCES Lab6..Stores(location_id) 
    ON DELETE SET DEFAULT ON UPDATE SET DEFAULT,
    phone_number NVARCHAR(12) NOT NULL
)
GO
INSERT Lab6..Stores (location_id, location, capacity)
VALUES ('100200300', 'Moscow, Pushkina str. 50', 1500);
INSERT Lab6..Stores (location_id, location, capacity)
VALUES ('200300400', 'St. Petersburg, Matros str. 24', 1000);
INSERT Lab6..Stores (location_id, location, capacity)
VALUES ('300400500', 'Ekaterinburg, Marxist str. 16', 560);
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (112, '100200300', '88005553535');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (224, '200300400', '89502224343');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (336, '300400500', '79653004005');
INSERT Lab6..Phone_numbers (phone_number_id, location_id, phone_number)
VALUES (448, '300400500', '79653004155');
GO
DELETE FROM Lab6..Stores WHERE location = 'St. Petersburg, Matros str. 24'
SELECT
    s.location_id,
    s.location
FROM
    Lab6..Stores as s
GROUP BY
    s.location_id, s.location;
SELECT
    p.location_id,
    p.phone_number_id
FROM
    Lab6..Phone_Numbers as p
GROUP BY
    p.phone_number_id, p.location_id;   */