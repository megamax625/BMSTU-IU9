USE master
GO  
 alter database Lab11 set single_user with rollback immediate
IF DB_ID (N'Lab11') IS NOT NULL
DROP DATABASE Lab11
GO
-- Create a new database
CREATE DATABASE Lab11
    ON ( NAME = Lab11_dat, FILENAME = "/var/opt/mssql/data/dbs/Lab11dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab11_log, FILENAME = "/var/opt/mssql/data/logs/Lab11log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
USE Lab11

IF OBJECT_ID('Lab11..Store', 'U') IS NOT NULL
DROP TABLE Lab11..Store
GO
CREATE TABLE Lab11..Store (
    Location_id INT IDENTITY(0, 1) NOT NULL PRIMARY KEY,    -- identity нельзя изменить с update
    [Location] NVARCHAR(200) NOT NULL,
    Work_Hours TEXT NOT NULL,
    Capacity Numeric(8,2) NOT NULL
)
GO
CREATE TRIGGER StoreDeleteTrig ON Lab11..Store
    INSTEAD OF DELETE
    AS BEGIN
        IF EXISTS ((SELECT * FROM Lab11..Pet 
                WHERE Pet.Location_id = Location_id AND Pet.Date_of_sale IS NULL)
            UNION (SELECT * FROM Lab11..Goods 
                WHERE Goods.Location_id = Location_id AND Goods.Available = 1)) 
        BEGIN
            PRINT 'Deletion of store prohibited:
            Available Goods or Pet detected'
            ROLLBACK
        END
        ELSE DELETE FROM Lab11..Store WHERE EXISTS(SELECT * FROM deleted
                         WHERE Store.Location_id = deleted.location_id)
    END
GO

IF OBJECT_ID('Lab11..Phone_Number', 'U') IS NOT NULL
DROP TABLE Lab11..Phone_Number
GO
CREATE TABLE Lab11..Phone_Number (
    Phone_number_id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Location_id INT FOREIGN KEY
    REFERENCES Lab11..Store(Location_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    Phone_number NVARCHAR(12) NOT NULL
)

IF OBJECT_ID('Lab11..Employee', 'U') IS NOT NULL
DROP TABLE Lab11..Employee
GO
CREATE TABLE Lab11..Employee (
    Employee_id INT IDENTITY(1000, 1) NOT NULL PRIMARY KEY,  -- ограничение для update автоматически
    [Name] NVARCHAR(30) NOT NULL,
    [Surname] NVARCHAR(30) NOT NULL,
    Patronymic NVARCHAR(30) NULL,
    Position INT NOT NULL,
    Currently_employed BIT NOT NULL
)

IF OBJECT_ID('Lab11..Consumer', 'U') IS NOT NULL
DROP TABLE Lab11..Consumer
GO
CREATE TABLE Lab11..Consumer (
    Consumer_id INT IDENTITY (10000, 1) NOT NULL PRIMARY KEY, -- ограничение для update автоматически
    E_mail NVARCHAR(320) NOT NULL,
    [Name] NVARCHAR(30) NOT NULL,
    [Surname] NVARCHAR(30) NOT NULL,
    Phone_number NVARCHAR(12) NULL,
    Bonuses INT NOT NULL DEFAULT 0
)


IF OBJECT_ID('Lab11..[Order]', 'U') IS NOT NULL
DROP TABLE Lab11..[Order]
GO

DECLARE @id UNIQUEIDENTIFIER
SET @id = NEWID();

CREATE TABLE Lab11..[Order] (
    Order_id UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL PRIMARY KEY
        CONSTRAINT DF_Order_rowguid DEFAULT NEWID(),
    Trade_date DATETIME NOT NULL,
    Receipt_number INT NOT NULL,
    Total_price MONEY NOT NULL,
    Payment_method INT NOT NULL,
    Location_id INT FOREIGN KEY
    REFERENCES Lab11..Store(Location_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    Employee_id INT FOREIGN KEY
    REFERENCES Lab11..Employee(Employee_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    Consumer_id INT FOREIGN KEY
    REFERENCES Lab11..Consumer(Consumer_id) ON DELETE NO ACTION ON UPDATE NO ACTION
)
GO
CREATE TRIGGER OrderUpdateTrig ON Lab11..[Order]
    AFTER UPDATE
    AS BEGIN
        IF UPDATE(Location_id) BEGIN
            PRINT 'Can not modify foreign key: Order must always refer to the Store where it was made'
            ROLLBACK
        END
        IF UPDATE(Employee_id) BEGIN
            PRINT 'Can not modify foreign key: 
            Order must always refer to the Employee who processed the order'
            ROLLBACK
        END
        IF UPDATE(Location_id) BEGIN
            PRINT 'Can not modify foreign key: 
            Order must always refer to the Consumer who placed the order'
            ROLLBACK
        END
    END
GO
CREATE TRIGGER OrderDeleteTrig ON Lab11..[Order]
    INSTEAD OF DELETE
    AS BEGIN
        PRINT 'Order deletion prohibited:
        data related to a transcation is never deleted'
        ROLLBACK
    END
GO

IF OBJECT_ID('Lab11..Pet', 'U') IS NOT NULL
DROP TABLE Lab11..Pet
GO
CREATE TABLE Lab11..Pet (
    Vet_certificate_number INT IDENTITY(0, 5) NOT NULL PRIMARY KEY,
    Genus NVARCHAR(30) NOT NULL,
    Species NVARCHAR(50) NOT NULL,
    Date_of_birth DATETIME NOT NULL,
    Price MONEY NOT NULL,
    Date_of_sale DATETIME NULL,
    Location_id INT NOT NULL FOREIGN KEY
    REFERENCES Lab11..Store(Location_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    Order_id UNIQUEIDENTIFIER FOREIGN KEY
    REFERENCES Lab11..[Order](Order_id) ON DELETE NO ACTION ON UPDATE NO ACTION
    DEFAULT NULL
)
GO
CREATE TRIGGER PetSellTrig ON Lab11..Pet
    AFTER UPDATE
    AS BEGIN
        IF UPDATE(Order_id) BEGIN
            IF EXISTS(SELECT * FROM deleted AS d
                WHERE d.Date_of_sale IS NOT NULL) BEGIN
                    RAISERROR('Cannot add Pet to order: Pet already sold', 1, 1)
                    ROLLBACK
            END
            UPDATE Pet
                SET Date_of_sale = GETDATE()
                FROM inserted
                WHERE  Pet.Vet_certificate_number = inserted.vet_certificate_number
        END
    END
GO
CREATE TRIGGER PetSellTrig2 ON Lab11..Pet
    INSTEAD OF DELETE
    AS BEGIN
        IF EXISTS(SELECT * FROM deleted AS d
        WHERE d.Date_of_sale IS NOT NULL) BEGIN
            RAISERROR('Cannot remove Pet: Pet already sold', 1, 1)
            ROLLBACK
        END
        UPDATE Pet
            SET Date_of_sale = GETDATE()
            FROM deleted
            WHERE  Pet.Vet_certificate_number = deleted.vet_certificate_number 
    END
GO
IF OBJECT_ID('Lab11..Goods', 'U') IS NOT NULL
DROP TABLE Lab11..Goods
GO
CREATE TABLE Lab11..Goods (
    Goods_id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Article_number INT NOT NULL,
    Batch_number INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(500) NOT NULL,
    Size NVARCHAR(15) NOT NULL,
    [Weight] Numeric(8,2) NOT NULL,
    Available BIT NOT NULL DEFAULT 0,
    Expiration_date DATETIME NOT NULL,
    Current_price MONEY NOT NULL,
    Location_id INT FOREIGN KEY
    REFERENCES Lab11..Store(Location_id) ON DELETE SET NULL ON UPDATE NO ACTION,  
)
GO
CREATE TRIGGER GoodsDeleteTrig ON Lab11..Goods
    INSTEAD OF DELETE
    AS BEGIN
        IF EXISTS (SELECT COUNT(*) FROM Lab11..Ordered_item 
                    WHERE Ordered_item.Goods_id = Goods_id) 
        BEGIN
            PRINT 'Deletion of Goods prohibited:
            data related to a transaction is never deleted'
            UPDATE Lab11..Goods
            SET Available = 0
            FROM deleted
            WHERE Goods.Goods_id = deleted.Goods_id
        END
        ELSE DELETE FROM Lab11..Goods WHERE EXISTS(SELECT * FROM deleted
                     WHERE Goods.Location_id = deleted.location_id)
    END
GO

IF OBJECT_ID('Lab11..Ordered_item', 'U') IS NOT NULL
DROP TABLE Lab11..Ordered_item
GO
CREATE TABLE Lab11..Ordered_item (
    Order_id UNIQUEIDENTIFIER FOREIGN KEY
    REFERENCES Lab11..[Order](Order_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    Goods_id INT FOREIGN KEY
    REFERENCES Lab11..Goods(Goods_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    PRIMARY KEY (Order_id, Goods_id),
    [Count] INT NOT NULL,
    Unit_price MONEY NOT NULL,
    Discount MONEY NOT NULL DEFAULT 0
)
GO
CREATE TRIGGER OrderedItemInsertTrig ON Lab11..Ordered_item
    AFTER INSERT
    AS BEGIN
        DECLARE @total_price MONEY
        IF EXISTS(SELECT * FROM Lab11..Goods, inserted AS i
            WHERE i.Goods_id = Goods.Goods_id AND Goods.Available = 0) BEGIN
                RAISERROR('Cannot add Goods to order: Goods unavailable', 1, 1)
                ROLLBACK
            END
        SET @total_price = (SELECT SUM([Count] * Unit_price - Discount) FROM inserted)
        UPDATE Lab11..[Order]
            SET [Order].Total_price = [Order].Total_price + @total_price
            WHERE [Order].Order_id = (SELECT TOP 1 Order_id FROM inserted)
    END
GO
CREATE TRIGGER OrderedItemUpdateTrig ON Lab11..Ordered_item
    INSTEAD OF UPDATE
    AS BEGIN
        PRINT   'Can not modify ordered items data - prohibited'
        ROLLBACK 
    END
GO
CREATE TRIGGER OrderedItemDeleteTrig ON Lab11..Ordered_item
    INSTEAD OF DELETE
    AS BEGIN
        PRINT   'Can not delete ordered items data - 
            data related to a transaction is never deleted'
        ROLLBACK 
    END
GO
INSERT Lab11..Store([Location], Work_Hours, Capacity)
VALUES  ('Moscow, Pushkina str. 50', '8:00-20:00', 1500),
        ('St. Petersburg, Matros str. 24', '8:00-20:00', 1000),
        ('Ekaterinburg, Marxist str. 16', '8:00-20:00' , 560);
INSERT Lab11..Phone_Number(Location_id, Phone_number)
VALUES  (0, '89005553535'),
        (0, '88885553535'),
        --  (-1, '83923423545'),  -- не добавляется т.к. нет такого location_id
        (2, '89502224343'),
        (1, '79653004005'),
        (2, '89653004085'),
        (0, '79999344455'),
        (1, '79653004155');
GO
SELECT s.[Location], COUNT(Phone_Number) as Count_of_phones
    FROM Lab11..Store AS s, Lab11..Phone_Number AS p
    WHERE s.location_id = p.Location_id
    GROUP BY s.[Location], s.Location_id
    ORDER BY s.[location_id] ASC
GO
SELECT s.[Location], COUNT(Phone_Number) as Count_of_phones
    FROM Lab11..Store AS s, Lab11..Phone_Number AS p
    WHERE s.location_id = p.Location_id
    GROUP BY s.[Location], s.Location_id
    ORDER BY s.[location_id] DESC
GO
INSERT Lab11..Employee([Name], [Surname], Position, Currently_employed)
VALUES ('Mike', 'Smith', 2, 1),
    ('Karen', 'Smith',  7, 1),
    ('John', 'Shikshin', 8, 0),
    ('George', 'Fried', 6, 1),
    ('Andrew', 'Smith', 4, 1);
INSERT Lab11..Consumer(E_mail, [Name], [Surname])
VALUES ('xx_Annihilator1337_xx@gmail.com', 'Bob', 'Pocker'),
    ('marleyK-1@yahoo.com', 'Kent', 'Marley'),
    ('jennytor@yandex.ru', 'Joanna', 'Jennings'),
    ('glowiercow@yahoo.com', 'Grzegorz', 'Brzęczyszczykiewicz');
GO
INSERT Lab11..Pet(Genus, Species, Date_of_birth, Price, Location_id)
VALUES ('Parrot', 'Cockatiel', DATEADD(m, -3, GETDATE()), 9700, 0),
    ('Parrot', 'Budgie', DATEADD(m, -1, GETDATE()), 3500, 2),
    ('Parrot', 'Budgie', DATEADD(m, -2, GETDATE()), 3000, 1),
    ('Hamster', 'Brown', DATEADD(m, -2, GETDATE()), 2500, 2),
    ('Hamster', 'Red', DATEADD(m, -5, GETDATE()), 3450, 1),
    ('Cat', 'White', DATEADD(m, -1, GETDATE()), 6000, 1),
    ('Cat', 'White', DATEADD(m, -1, GETDATE()), 6000, 2),
    ('Parrot', 'Cockatoo', DATEADD(m, -7, GETDATE()), 25000, 0);
GO
INSERT Lab11..Goods(Article_number, Batch_number, Title, [Description], 
Size, [Weight], Available, Expiration_date, Current_price, Location_id)
VALUES (1234, 1200, 'Parrot Toy', '', '10x10x5cm', 0.1, 1, DATEADD(y, 5, GETDATE()), 750, 0),
 (1234, 1250, 'Parrot Toy', '', '10x10x5cm', 0.1, 1, DATEADD(y, 5, GETDATE()), 700, 1),
 (1234, 1300, 'Parrot Toy', '', '10x10x5cm', 0.1, 1, DATEADD(y, 5, GETDATE()), 650, 2),
 (2345, 1350, 'Parrot Cage', '', '80x100x150cm', 5, 1, DATEADD(y, 15, GETDATE()), 7500, 0),
 (2345, 1375, 'Parrot Cage', '', '80x100x150cm', 5, 1, DATEADD(y, 15, GETDATE()), 6800, 1),
 (2345, 1400, 'Parrot Cage', '', '80x100x150cm', 5, 1, DATEADD(y, 15, GETDATE()), 6000, 2),
 (3456, 1500, 'Parrot Food', '', '10x5x35cm', 2, 1, DATEADD(y, 1, GETDATE()), 999, 0),
 (3456, 1550, 'Parrot Food', '', '10x5x35cm', 2, 1, DATEADD(y, 1, GETDATE()), 888, 1),
 (3456, 1600, 'Parrot Food', '', '10x5x35cm', 2, 1, DATEADD(y, 1, GETDATE()), 777, 2),
 (4567, 2000, 'Cat Food', '', '10x5x35cm', 2, 1, DATEADD(y, 1, GETDATE()), 1500, 0),
 (4567, 2050, 'Cat Food', '', '10x5x35cm', 2, 1, DATEADD(y, 1, GETDATE()), 1000, 1),
 (4567, 2100, 'Cat Food', '', '10x5x35cm', 2, 1, DATEADD(y, 1, GETDATE()), 750, 2),
 (5678, 3000, 'Hamster Food', '', '10x5x35cm', 2, 1, DATEADD(y, 1, GETDATE()), 1000, 0),
 (5678, 3050, 'Hamster Food', '', '10x5x35cm', 2, 1, DATEADD(y, 1, GETDATE()), 750, 1),
 (5678, 3100, 'Hamster Food', '', '10x5x35cm', 2, 1, DATEADD(y, 1, GETDATE()), 500, 2);
GO
IF OBJECT_ID (N'dbo.GetSumOfPrices', 'F') IS NOT NULL
DROP FUNCTION dbo.GetSumOfPrices
GO
DECLARE @sum MONEY
DECLARE @location NVARCHAR(200)
SET @sum = (SELECT SUM(current_price) 
        FROM Lab11..Goods WHERE Goods.Location_id = 0)
SET @location = (SELECT [location] FROM Lab11..Store WHERE Store.location_id = 0)
PRINT 'Sum of prices of Goods in ' + @location + ' is ' + CAST(@sum AS VARCHAR)
SET @sum = (SELECT SUM(current_price) 
        FROM Lab11..Goods WHERE Goods.Location_id = 1)
SET @location = (SELECT [location] FROM Lab11..Store WHERE Store.location_id = 1)
PRINT 'Sum of prices of Goods in ' + @location + ' is ' + CAST(@sum AS VARCHAR)
SET @sum = (SELECT SUM(current_price) 
        FROM Lab11..Goods WHERE Goods.Location_id = 2)
SET @location = (SELECT [location] FROM Lab11..Store WHERE Store.location_id = 2)
PRINT 'Sum of prices of Goods in ' + @location + ' is ' + CAST(@sum AS VARCHAR)
GO
DROP SEQUENCE IF EXISTS CountBy1
GO
CREATE SEQUENCE CountBy1
    START WITH 100000000
    INCREMENT BY 1;
GO
INSERT Lab11..[Order](Trade_date, Receipt_number, Total_price, 
        Payment_method, Location_id, Employee_id, Consumer_id)
VALUES ('2022-12-14 12:00:00', NEXT VALUE FOR CountBy1, 0, 1, 0, 1000, 10000),
       ('2022-12-14 13:00:00', NEXT VALUE FOR CountBy1, 0, 0, 1, 1003, 10001),
       ('2022-12-13 12:00:00', NEXT VALUE FOR CountBy1, 0, 1, 2, 1004, 10002);
GO

INSERT Lab11..Ordered_item(Order_id, Goods_id, [Count], Unit_price, Discount)
SELECT (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-14 12:00:00' AND Consumer_id = 10000),
    (SELECT Goods.Goods_id FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1200), 
    2, (SELECT Goods.Current_price FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1200), 
    50 FROM Lab11..Goods AS Goods
UNION
SELECT (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-14 12:00:00' AND Consumer_id = 10000),
    (SELECT Goods.Goods_id FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1350),
    1, (SELECT Goods.Current_price FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1350), 
    100 FROM Lab11..Goods AS Goods
UNION
SELECT (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-14 12:00:00' AND Consumer_id = 10000),
    (SELECT Goods.Goods_id FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1500), 
    2, (SELECT Goods.Current_price FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1500), 
    50 FROM Lab11..Goods AS Goods
UPDATE Lab11..Pet
    SET Order_id = (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-14 12:00:00' AND Consumer_id = 10000) WHERE Vet_certificate_number = 0
DELETE FROM Lab11..Goods WHERE Batch_number IN (1200, 1500)

INSERT Lab11..Ordered_item(Order_id, Goods_id, [Count], Unit_price, Discount)
SELECT (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-14 13:00:00' AND Consumer_id = 10001),
    (SELECT Goods.Goods_id FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 3000), 
    3, (SELECT Goods.Current_price FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 3000), 
    50 FROM Lab11..Goods AS Goods
UNION
SELECT (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-14 13:00:00' AND Consumer_id = 10001),
    (SELECT Goods.Goods_id FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 2000),
    3, (SELECT Goods.Current_price FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 2000), 
    50 FROM Lab11..Goods AS Goods

DELETE FROM Lab11..Goods WHERE Batch_number IN (2000, 3000)

INSERT Lab11..Ordered_item(Order_id, Goods_id, [Count], Unit_price, Discount)
SELECT (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-13 12:00:00' AND Consumer_id = 10002),
    (SELECT Goods.Goods_id FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1300), 
    2, (SELECT Goods.Current_price FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1300), 
    50 FROM Lab11..Goods AS Goods
UNION
SELECT (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-13 12:00:00' AND Consumer_id = 10002),
    (SELECT Goods.Goods_id FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1400),
    1, (SELECT Goods.Current_price FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1400), 
    100 FROM Lab11..Goods AS Goods
UNION
SELECT (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-13 12:00:00' AND Consumer_id = 10002),
    (SELECT Goods.Goods_id FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1350),
    1, (SELECT Goods.Current_price FROM Lab11..Goods as Goods WHERE Goods.Batch_number = 1350), 
    100 FROM Lab11..Goods AS Goods
UPDATE Lab11..Pet
    SET Order_id = (SELECT TOP 1 Order_id FROM Lab11..[Order] 
        WHERE Trade_date = '2022-12-13 12:00:00' AND Consumer_id = 10002) WHERE Vet_certificate_number = 5
DELETE FROM Lab11..Goods WHERE Batch_number IN (1300, 1400)

SELECT Goods_id, Batch_number, Title, Current_price, Available, Location_id FROM Lab11..Goods

GO

SELECT * FROM Lab11..Ordered_item
SELECT * FROM Lab11..[Order]
SELECT AVG(Total_price) AS [Average Order Price] FROM Lab11..[Order]
SELECT Goods_id as id, Batch_number as [Batch Number], Title, Current_price as [Current Price], 
       Available, Location_id as [Location id] FROM Lab11..Goods
    WHERE Current_price > (SELECT AVG(Current_price) FROM Lab11..Goods)
GO
SELECT Goods_id as id, Batch_number as [Batch Number], Title, Current_price as [Current Price], 
       Available, Location_id as [Location id] FROM Lab11..Goods
    WHERE (Current_price > (SELECT MIN(Current_price) FROM Lab11..Goods) + 200)
        AND (Current_price < (SELECT MAX(Current_price) FROM Lab11..Goods) - 500)
GO
SELECT Goods_id, Title, Current_price as [Current_price], Location_id
    FROM Lab11..Goods WHERE Batch_number BETWEEN 1350 AND 1500
GO
SELECT DISTINCT Title FROM Lab11..Goods
GO
SELECT Title, Current_price, [Location]
    FROM Lab11..Goods INNER JOIN Lab11..Store ON Store.Location_id = Goods.Location_id
    AND Available = 1
    GROUP BY Store.[Location], Title, Current_price, Available
    ORDER BY Store.[Location] ASC, Current_price DESC
GO 
SELECT Title, SUM(Current_Price)
    FROM Lab11..Goods
    GROUP BY Title
    HAVING SUM(Current_price) > 2500
GO
SELECT Batch_number, Title, Current_price, Available, Location_id FROM Lab11..Goods
    WHERE Title LIKE '%Parrot%'
GO
SELECT Current_Price, Title FROM Lab11..Goods
UNION ALL
SELECT Price, Species + ' ' + Genus as Title FROM Lab11..Pet
GO
SELECT Current_Price, Title FROM Lab11..Goods
UNION
SELECT Price, Species + ' ' + Genus as Title FROM Lab11..Pet
EXCEPT
SELECT Current_Price, Title FROM Lab11..Goods WHERE Title LIKE '%Food%'
GO
SELECT Current_Price FROM Lab11..Goods
INTERSECT
SELECT Price FROM Lab11..Pet
GO
SELECT Species + ' ' + Genus as Title, Date_of_sale, Price
    FROM Lab11..Pet LEFT JOIN Lab11..[Order] ON Pet.Order_id = [Order].Order_id
SELECT Ordered_item.Order_id, Batch_Number, Title
    FROM Lab11..Ordered_item RIGHT JOIN Lab11..Goods ON 
        EXISTS(SELECT Goods.Goods_id WHERE Goods.Goods_id = Ordered_item.Goods_id)
GO
SELECT Trade_date, Title, Unit_price, [Count], [Name] + ' ' + [Surname] as Customer
    FROM Lab11..[Order]
    FULL OUTER JOIN Lab11..Consumer
    ON [Order].Consumer_id = Consumer.Consumer_id
    FULL OUTER JOIN Lab11..Ordered_item
    ON [Ordered_item].Order_id = [Order].Order_id
    FULL OUTER JOIN Lab11..Goods
    ON Ordered_item.Goods_id = Goods.Goods_id
    ORDER BY Customer DESC