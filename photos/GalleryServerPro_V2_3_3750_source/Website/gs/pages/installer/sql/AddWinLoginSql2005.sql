/* Add Windows login to SQL 2005 and higher. Add login to database. */
DECLARE @UserName varchar(200)
DECLARE @DbName varchar(200)
SET @UserName = N'#GalleryServerWebUserName#'
SET @DbName = N'#DbName#'

BEGIN TRAN

/* Create login if it doesn't exist */
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @UserName AND type = 'U')
	EXEC ('CREATE LOGIN [' + @UserName + '] FROM WINDOWS WITH DEFAULT_DATABASE=[' + @DbName + ']')

IF @@ERROR > 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = @UserName AND type = 'U')
	EXEC ('CREATE USER [' + @UserName + '] FOR LOGIN [' + @UserName + ']')

IF @@ERROR > 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN

GO
