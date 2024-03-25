USE master
GO
IF DB_ID ('Lab5') IS NOT NULL
DROP DATABASE Lab5
GO
-- 1) Create a new database
CREATE DATABASE Lab5
    ON ( NAME = Lab5_dat, FILENAME = "/var/opt/mssql/data/dbs/lab5dat.mdf",
        SIZE = 20 MB, MAXSIZE = UNLIMITED, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab5_log, FILENAME = "/var/opt/mssql/data/logs/lab5log.ldf",
        SIZE = 10 MB, MAXSIZE = 30 MB, FILEGROWTH = 10 MB)
GO
use Lab5
-- 2) Create a new table
IF OBJECT_ID('Lab5..Employees', 'U') IS NOT NULL
DROP TABLE Lab5..Employees
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
DROP TABLE dbo.Employees
GO
CREATE TABLE Lab5..Employees (
    employee_id INT NOT NULL PRIMARY KEY,
    "name" NVARCHAR(30) NOT NULL,
    surname NVARCHAR(30) NOT NULL,
    patronymic NVARCHAR(30) NOT NULL,
    position INT NOT NULL
);
GO
-- 3) Add a file group and file
ALTER DATABASE Lab5
    ADD FILEGROUP LargeFileGroup
ALTER DATABASE Lab5
    ADD FILE 
    (   NAME = Lab5_LargeData,
        FILENAME = "/var/opt/mssql/data/dbs/lab5dat1.ndf",
        SIZE = 30 MB,
        MAXSIZE = 100 MB,
        FILEGROWTH = 5%
    ) TO FILEGROUP LargeFileGroup
GO
-- 4) Make a new file group primary
ALTER DATABASE Lab5
    MODIFY FILEGROUP LargeFileGroup DEFAULT
GO
-- 5) Create another table
ALTER DATABASE Lab5
    ADD FILE
    (   NAME = Lab5_NewData,
        FILENAME = "/var/opt/mssql/data/dbs/lab5dat2.ndf",
        SIZE = 25 MB,
        MAXSIZE = 75 MB,
        FILEGROWTH = 5%
    ) TO FILEGROUP [PRIMARY]
IF OBJECT_ID('Lab5..Consumers', 'U') IS NOT NULL
DROP TABLE Lab5..Consumers
GO
CREATE TABLE Lab5..Consumers (
    consumer_id INT NOT NULL,
    e_mail NVARCHAR(320) NOT NULL,
    "name" NVARCHAR(30) NOT NULL,
    surname NVARCHAR(30) NOT NULL,
    phone_number NVARCHAR(12) NULL,
    bonuses INT NOT NULL,
    CONSTRAINT PK_Consumers PRIMARY KEY NONCLUSTERED (consumer_id)
    ) ON LargeFileGroup;
GO
-- 6) Delete new file group
CREATE UNIQUE CLUSTERED INDEX PK_Consumers_CL ON dbo.Consumers(consumer_id)
    WITH (ONLINE = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Consumers
    DROP CONSTRAINT PK_Consumers
GO
ALTER DATABASE Lab5
    MODIFY FILEGROUP [PRIMARY] DEFAULT
ALTER DATABASE Lab5 REMOVE FILE Lab5_LargeData
ALTER DATABASE Lab5 REMOVE FILEGROUP LargeFileGroup
GO
-- 7) Create schema, move one table into schema, delete schema
IF OBJECT_ID('production.Goods', 'U') IS NOT NULL
DROP TABLE production.Goods
GO
IF OBJECT_ID('production.Employees', 'U') IS NOT NULL
DROP TABLE production.Employees
GO
IF SCHEMA_ID('production') IS NOT NULL
DROP SCHEMA production
GO
CREATE SCHEMA production
GO
CREATE TABLE production.Goods (
    goods_id INT NOT NULL,
    article_number INT NOT NULL,
    batch_number INT NOT NULL,
    title NVARCHAR(100) NOT NULL,
    description NVARCHAR(100) NOT NULL,
    expiration_date DATETIME NOT NULL,
    current_price MONEY NOT NULL
)
ALTER SCHEMA production
    TRANSFER dbo.Employees
DROP TABLE production.Goods
DROP TABLE production.Employees
DROP SCHEMA production
