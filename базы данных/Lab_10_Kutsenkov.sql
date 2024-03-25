USE master
GO
IF DB_ID (N'Lab10') IS NOT NULL
DROP DATABASE Lab10
GO
-- Create a new database
CREATE DATABASE Lab10
    ON ( NAME = Lab10_dat, FILENAME = "/var/opt/mssql/data/dbs/Lab10dat.mdf",
        SIZE = 10 MB, MAXSIZE = 20 MB, FILEGROWTH = 5%)
    LOG ON ( NAME = Lab10_log, FILENAME = "/var/opt/mssql/data/logs/Lab10log.ldf",
        SIZE = 5 MB, MAXSIZE = 10 MB, FILEGROWTH = 10 MB)
GO
USE Lab10

IF OBJECT_ID('Lab10..[Data]', 'U') IS NOT NULL
DROP TABLE Lab10..[Data]
GO
CREATE TABLE Lab10..[Data] (
    [data_id] INT IDENTITY(0, 5) NOT NULL PRIMARY KEY,
    number1 INT NOT NULL,
    number2 INT NOT NULL
)
GO
INSERT INTO Lab10..[Data] (number1, number2)
VALUES (1, 2), (3, 4), (5, 6), (7, 8), (9, 10)
SELECT * FROM Lab10..[Data]
GO
-- грязное чтение (dirty read)
BEGIN TRANSACTION
UPDATE Lab10..[Data] SET number2 = 20
SELECT * FROM Lab10..[Data]
WAITFOR DELAY '00:00:10'
ROLLBACK
GO

SET TRANSACTION ISOLATION LEVEL  READ UNCOMMITTED  -- выполняется, не дожидаясь окончания транзакции
                                -- READ COMMITTED  -- дожидается окончания первой транзакции
                                -- REPEATABLE READ -- дожидается окончания первой транзакции
                                -- SERIALIZABLE    -- дожидается окончания первой транзакции
BEGIN TRANSACTION
SELECT * FROM Lab10..[Data]
GO
SELECT   
    resource_type, request_mode FROM sys.dm_tran_locks
    WHERE request_session_id = @@spid
GO
COMMIT
GO
-- невоспроизводимое чтение (non-repeatable read)
SET TRANSACTION ISOLATION LEVEL -- READ UNCOMMITTED -- данные изменены
                                 READ COMMITTED  -- данные изменены  
                                -- REPEATABLE READ -- данные не изменяются
                                -- SERIALIZABLE    -- данные не изменяются
BEGIN TRANSACTION
SELECT * FROM Lab10..[Data]
WAITFOR DELAY '00:00:10'
SELECT * FROM Lab10..[Data]
GO
SELECT   
    resource_type, request_mode FROM sys.dm_tran_locks
    WHERE request_session_id = @@spid
GO
ROLLBACK
GO

BEGIN TRANSACTION
UPDATE Lab10..[Data] SET number1 = number1 + 2
WAITFOR DELAY '00:00:10'
SELECT * FROM Lab10..[Data]
COMMIT
GO
-- фантомное чтение (phantom read)
SET TRANSACTION ISOLATION LEVEL -- READ UNCOMMITTED -- фантомное чтение имеется
                                -- READ COMMITTED  -- фантомное чтение имеется
                                 REPEATABLE READ -- фантомное чтение имеется
                                -- SERIALIZABLE     -- фантомного чтения нет
BEGIN TRANSACTION
SELECT * FROM Lab10..[Data]
WAITFOR DELAY '00:00:10'
SELECT * FROM Lab10..[Data]
GO
SELECT   
    resource_type, request_mode, resource_description FROM sys.dm_tran_locks
    WHERE request_session_id = @@spid
GO
ROLLBACK
GO

BEGIN TRANSACTION
INSERT INTO Lab10..[Data]
VALUES (201, 202), (203, 204)
WAITFOR DELAY '00:00:03'
SELECT * FROM Lab10..[Data]
COMMIT
GO
WAITFOR DELAY '00:00:10'
DELETE FROM Lab10..[Data] WHERE number1 IN (201, 203)
GO

-- режимы lock'ов в request_mode:
-- S - Shared lock - резервирует только для чтения
-- IS - Intent shared 
-- X - Exclusive lock - зарезервировано исключительно для транзакции, накладывающей его
-- IX - Intent exclusive
-- RangeS-S - Shared range, shared resource lock; serializable range scan