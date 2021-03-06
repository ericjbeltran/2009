/* Add Windows login to SQL 2000 and earlier. Add login to database. */
DECLARE @UserName varchar(200)
DECLARE @DbName varchar(200)
SET @UserName = N'#GalleryServerWebUserName#'
SET @DbName = N'#DbName#'

/* Create login if it doesn't exist */
EXEC ('use master')
IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = @UserName)
BEGIN
	EXEC master..sp_grantlogin @UserName
	EXEC master..sp_defaultdb @UserName, @DbName
END

EXEC ('use [' + @DbName + ']')
IF NOT EXISTS (SELECT * FROM dbo.sysusers where name = @UserName and uid < 16382)
	EXEC sp_grantdbaccess @UserName, @UserName
GO
