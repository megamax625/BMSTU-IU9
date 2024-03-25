USE master
GO
IF DB_ID (N'Lab8') IS NOT NULL
DROP DATABASE Lab8
GO
-- Create a new database
CREATE DATABASE Lab8
    ON ( NAME = Lab8_dat, FILENAME = "/var/opt/mssql/data/dbs/lab8dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab8_log, FILENAME = "/var/opt/mssql/data/logs/lab8log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
USE Lab8
IF OBJECT_ID('Lab8..Goods', 'U') IS NOT NULL
DROP TABLE Lab8..Goods
GO
CREATE TABLE Lab8..Goods (
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
INSERT Lab8..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (130500, 2050, 'Parrot toy', '2025-10-12', 350),
    (130500, 2150, 'Parrot toy', '2023-10-12', 505),
    (130500, 2550, 'Parrot toy', '2023-10-12', 750),
    (130500, 2650, 'Parrot toy', '2023-10-12', 300),
    (150500, 2150, 'Parrot cage', '2045-10-10', 7000),
    (150500, 2170, 'Parrot cage', '2030-10-10', 8700),
    (230300, 3450, 'Cat food', '2022-12-12', 800),
    (350400, 4560, 'Dog food', '2023-01-01', 1200);
GO
-- 1) Создать хранимую процедуру, производящую выборку из нек. таблицы
-- и возвращающую результат выборки в виде курсора
IF OBJECT_ID (N'dbo.GetProductsByGenus', 'P') IS NOT NULL
DROP PROCEDURE dbo.GetProductsByGenus
GO

CREATE PROCEDURE dbo.GetProductsByGenus
    @genus NVARCHAR(100),
    @products_cursor CURSOR VARYING OUTPUT
AS
    SET @products_cursor = CURSOR
    FORWARD_ONLY STATIC FOR
    SELECT title, expiration_date, current_price
    FROM Lab8..Goods WHERE title LIKE '%' + @genus + '%'
OPEN @products_cursor;
GO

DECLARE @MyCursor CURSOR
DECLARE @title NVARCHAR(100), @exp_date DATETIME, @price MONEY
EXEC dbo.GetProductsByGenus N'Parrot', @products_cursor = @MyCursor OUTPUT;

-- изменения не отражаются в курсоре, так как он статический
DELETE FROM Lab8..Goods WHERE current_price = 300
UPDATE Lab8..Goods
SET current_price = 9000
WHERE title LIKE '%cage' AND current_price = 7000

FETCH NEXT FROM @MyCursor INTO @title, @exp_date, @price
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @title + ' ' + CAST(@price AS VARCHAR)
    FETCH NEXT FROM @MyCursor INTO @title, @exp_date, @price
END
CLOSE @MyCursor
DEALLOCATE @MyCursor
GO

INSERT Lab8..Goods 
    (article_number, batch_number, title, expiration_date, current_price)
VALUES
    (130500, 2650, 'Parrot toy', '2023-10-12', 300)
GO
-- 2) Модифицировать хранимую процедуру п.1 т.о., чтобы выборка
-- осуществлялась с формированием столбца, значение которого
-- формируется пользовательской функцией
IF OBJECT_ID (N'dbo.GetValuePerDay', 'F') IS NOT NULL
DROP FUNCTION dbo.GetValuePerDay
GO

CREATE FUNCTION dbo.GetValuePerDay (@exp_time DATETIME, @curr_price MONEY)
RETURNS MONEY
AS BEGIN
    DECLARE @res MONEY
    DECLARE @days_left INT
    SET @days_left = DATEDIFF(day, GETDATE(), @exp_time)
    SET @res = @curr_price / CAST(@days_left AS decimal(10,2))
    RETURN @res
END
GO
IF OBJECT_ID (N'dbo.GetProductsByGenus2', 'P') IS NOT NULL
DROP PROCEDURE dbo.GetProductsByGenus2
GO

CREATE PROCEDURE dbo.GetProductsByGenus2
    @genus NVARCHAR(100),
    @products_cursor CURSOR VARYING OUTPUT
AS
    SET @products_cursor = CURSOR
    FORWARD_ONLY STATIC FOR
    SELECT title, expiration_date, current_price, 
        dbo.GetValuePerDay(expiration_date, current_price)
    FROM Lab8..Goods WHERE title LIKE '%' + @genus + '%'
OPEN @products_cursor;
GO

DECLARE @MyCursor CURSOR
DECLARE @title NVARCHAR(100), @exp_date DATETIME, @price MONEY, @value MONEY
EXEC dbo.GetProductsByGenus2 N'Parrot', @products_cursor = @MyCursor OUTPUT;

FETCH NEXT FROM @MyCursor INTO @title, @exp_date, @price, @value
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @title + ' costing ' + CAST(@price AS VARCHAR) + ' has ' + 
        CAST(@value AS VARCHAR) + ' value per day till expiration:' + 
        + CAST(DATEDIFF(day, GETDATE(), @exp_date) AS VARCHAR) + ' days till expiration'
    FETCH NEXT FROM @MyCursor INTO @title, @exp_date, @price, @value
END
CLOSE @MyCursor
DEALLOCATE @MyCursor
GO

-- 3) Создать хранимую процедуру, вызывающую процедуру п.1,
-- осуществляющую прокрутку возвращаемого курсора и выводящую сообщения,
-- сформированные из записей при выполнении условия, заданного ещё одной
-- пользовательской функцией
IF OBJECT_ID (N'dbo.GetAveragePrice', 'F') IS NOT NULL
DROP FUNCTION dbo.GetAveragePrice
GO

CREATE FUNCTION dbo.GetAveragePrice (@type NVARCHAR(100))
RETURNS MONEY
AS BEGIN
    DECLARE @avg MONEY
    SELECT @avg = AVG(current_price) 
    FROM Lab8..Goods WHERE title LIKE '%' + @type + '%'
    RETURN @avg
END
GO
SELECT dbo.GetAveragePrice('toy') AS AvgPriceOfToys
GO
IF OBJECT_ID (N'dbo.MoreExpensiveThanAVGofType', 'F') IS NOT NULL
DROP FUNCTION dbo.MoreExpensiveThanAVGofType
GO
CREATE FUNCTION dbo.MoreExpensiveThanAVGofType 
                (@type NVARCHAR(100), @price MONEY)
RETURNS BIT
AS BEGIN
    IF @price > dbo.GetAveragePrice(@type)
        RETURN 1
    RETURN 0
END
GO

IF OBJECT_ID (N'dbo.GetExpensiveProductsByGenus', 'P') IS NOT NULL
DROP PROCEDURE dbo.GetExpensiveProductsByGenus
GO

CREATE PROCEDURE dbo.GetExpensiveProductsByGenus
    @genus NVARCHAR(100),
    @type NVARCHAR(100),
    @products_cursor CURSOR VARYING OUTPUT
AS
    SET @products_cursor = CURSOR
    SCROLL STATIC FOR       -- SCROLL т.к. будем делать выборку с конца
    SELECT title, expiration_date, current_price
    FROM Lab8..Goods WHERE title LIKE '%' + @genus + '%' + @type + '%'
OPEN @products_cursor;
GO

DECLARE @title NVARCHAR(100), @exp_date DATETIME, @price MONEY
DECLARE @MyCursor CURSOR;
DECLARE @type AS NVARCHAR(100) = 'toy'
EXEC dbo.GetExpensiveProductsByGenus N'Parrot', N'toy', 
                                        @products_cursor = @MyCursor OUTPUT;

FETCH LAST FROM @MyCursor INTO @title, @exp_date, @price
WHILE @@FETCH_STATUS = 0
BEGIN
    IF dbo.MoreExpensiveThanAVGofType(@type, @price) = 1
        PRINT 'Expensive ' + @type + ': ' + @title + ' for ' + CAST(@price AS VARCHAR)
    FETCH PRIOR FROM @MyCursor INTO @title, @exp_date, @price
END
CLOSE @MyCursor
DEALLOCATE @MyCursor
GO

-- 4) Модифицировать хранимую процедуру п.2, т.о., чтобы выборка формировалась
-- с помощью табличной функции
IF OBJECT_ID (N'dbo.GetTableFetcher', 'F') IS NOT NULL
DROP FUNCTION dbo.GetTableFetcher
GO
CREATE FUNCTION dbo.GetTableFetcher(@genus NVARCHAR(100))
RETURNS TABLE AS RETURN 
    (
        SELECT g.title, g.expiration_date, g.current_price, 
        dbo.GetValuePerDay(g.expiration_date, g.current_price) AS [value]
        FROM Lab8..Goods AS g WHERE g.title LIKE '%' + @genus + '%'
    );
GO
IF OBJECT_ID (N'dbo.GetTableFetcher2', 'F') IS NOT NULL
DROP FUNCTION dbo.GetTableFetcher2
GO
CREATE FUNCTION dbo.GetTableFetcher2(@genus NVARCHAR(100))
RETURNS @Fetcher TABLE (
        title NVARCHAR(100),
        exp_date DATETIME,
        price MONEY,
        [value] MONEY
) AS BEGIN
        INSERT INTO @Fetcher
        SELECT g.title, g.expiration_date, g.current_price, 
        dbo.GetValuePerDay(g.expiration_date, g.current_price)
        FROM Lab8..Goods AS g WHERE g.title LIKE '%' + @genus + '%'
        RETURN
    END
GO
SELECT * FROM dbo.GetTableFetcher(N'Parrot')
UNION
SELECT * FROM dbo.GetTableFetcher2(N'Parrot')
GO
IF OBJECT_ID (N'dbo.GetProductsByTable', 'P') IS NOT NULL
DROP PROCEDURE dbo.GetProductsByTable
GO
CREATE PROCEDURE dbo.GetProductsByTable
    @genus NVARCHAR(100),
    @products_cursor CURSOR VARYING OUTPUT
AS
    SET @products_cursor = CURSOR
    SCROLL STATIC FOR
    SELECT * FROM dbo.GetTableFetcher(@genus)
OPEN @products_cursor;
GO

DECLARE @MyCursor CURSOR
DECLARE @title NVARCHAR(100), @exp_date DATETIME, @price MONEY, @value MONEY
EXEC dbo.GetProductsByTable N'Parrot', @products_cursor = @MyCursor OUTPUT;

FETCH LAST FROM @MyCursor INTO @title, @exp_date, @price, @value
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @title + ' costing ' + CAST(@price AS VARCHAR) + ' has ' + 
        CAST(@value AS VARCHAR) + ' value per day till expiration:' + 
        + CAST(DATEDIFF(day, GETDATE(), @exp_date) AS VARCHAR) + ' days till expiration '
    FETCH PRIOR FROM @MyCursor INTO @title, @exp_date, @price, @value
END
CLOSE @MyCursor
DEALLOCATE @MyCursor
GO