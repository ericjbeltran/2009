/* Add SQL login to SQL 2005 and higher. Add login to database. */
DECLARE @UserName varchar(200)
DECLARE @Password varchar(200)
DECLARE @DbName varchar(200)
SET @UserName = N'#GalleryServerWebUserName#'
SET @Password = N'#GalleryServerWebUserPwd#'
SET @DbName = N'#DbName#'

BEGIN TRAN

/* Create login if it doesn't exist */
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @UserName AND type = 'S')
	EXEC ('CREATE LOGIN [' + @UserName + '] WITH PASSWORD=''' + @Password + ''', DEFAULT_DATABASE=[' + @DbName + ']')

IF @@ERROR > 0
BEGIN
	ROLLBACK TRAN
	RETURN
END
	
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = @UserName AND type = 'S')
	EXEC ('CREATE USER [' + @UserName + '] FOR LOGIN [' + @UserName + ']')
	
IF @@ERROR > 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN

GO
