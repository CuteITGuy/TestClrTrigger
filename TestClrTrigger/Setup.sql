/*

USE [TEST]
GO

EXEC sys.sp_configure
	@configname = 'show advanced option',
	@configvalue = 1
GO

RECONFIGURE
GO

EXEC sys.sp_configure
	@configname = 'clr enabled',
	@configvalue = 1
GO

RECONFIGURE
GO

EXEC sys.sp_configure
	@configname = 'show advanced option',
	@configvalue = 0
GO

RECONFIGURE
GO

ALTER DATABASE TEST SET TRUSTWORTHY ON
GO

IF OBJECT_ID(N'func_ToTitleCase', 'FS') IS NOT NULL
BEGIN
	DROP FUNCTION dbo.func_ToTitleCase
END
GO

IF OBJECT_ID(N'trig_PeopleInserted', 'TA') IS NOT NULL
BEGIN
	DROP TRIGGER trig_PeopleInserted
END
GO

IF EXISTS
(
	SELECT *
	FROM sys.assemblies
	WHERE sys.assemblies.name = 'SqlTrigger'
)
BEGIN
	DROP ASSEMBLY SqlTrigger
END
GO

IF EXISTS
(
	SELECT *
	FROM sys.assemblies
	WHERE sys.assemblies.name = 'SocketClient'
)
BEGIN
	DROP ASSEMBLY SocketClient
END
GO

IF EXISTS
(
	SELECT *
	FROM sys.assemblies
	WHERE sys.assemblies.name = 'SocketCommon'
)
BEGIN
	DROP ASSEMBLY SocketCommon
END
GO

CREATE ASSEMBLY SocketCommon FROM
N'F:\C#\Test\TestClrTrigger\TestClrTrigger\bin\Release\SocketCommon.dll' WITH PERMISSION_SET =
UNSAFE
GO

CREATE ASSEMBLY SocketClient FROM
N'F:\C#\Test\TestClrTrigger\TestClrTrigger\bin\Release\SocketClient.dll' WITH PERMISSION_SET =
UNSAFE
GO

CREATE ASSEMBLY SqlTrigger FROM
N'F:\C#\Test\TestClrTrigger\TestClrTrigger\bin\Release\TestClrTrigger.dll' WITH PERMISSION_SET =
UNSAFE
GO

CREATE TRIGGER trig_PeopleInserted ON People
AFTER INSERT
AS
EXTERNAL NAME SqlTrigger.Triggers.SqlTrigger
GO

CREATE FUNCTION func_ToTitleCase
(
	@text NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
EXTERNAL NAME
SqlTrigger.UserDefinedFunctions.ToTitleCase
GO

INSERT INTO People (Id, Name, Age)
VALUES
(
	114, -- Id - int
	N'Benklin', -- Name - nvarchar
	0 -- Age - int
)
GO

*/