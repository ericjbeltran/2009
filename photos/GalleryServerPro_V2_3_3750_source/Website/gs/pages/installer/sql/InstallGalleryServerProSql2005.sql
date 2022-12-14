/**********************************************************************/
/* InstallGalleryServerProSql2005.sql                              

** Copyright Tech Info Systems, LLC 2010. All Rights Reserved.
                                     
 Installs the tables, stored procedures, user-defined functions, and roles necessary for  
 core Gallery Server Pro operation. This script runs on SQL Server 2005 and later.
 
 There are several sections:
 1. Delete database role, tables, stored procedures, and user-defined functions related to 
    Gallery Server Pro. Does not delete ASP.NET Membership, Role, or Profile objects. 
 
 2. Create role, tables, stored procedures, and user-defined functions.
 
 3. Create database role and configure permissions for this role.
 
 4. Add ASP.NET Membership, Role, or Profile database roles to GSP role (gs_GalleryServerProRole).
 
 NOTES:
 1. To manually execute this script you must perform a search and replace operation
    for {schema} and {objectQualifier}.
    {schema} - This is the schema that the database objects belong to. If you are not
    sure what to use, use "[dbo]." (without the quotes).
    {objectQualifier} - This is a prefix that is prepended to each database object name.
    May be replaced with an empty string, in which case all objects will begin with "gs_".
    
  2. (Note to DotNetNuke developer) When porting this script to the DotNetNuke module:
    a) Do not include section 4.
    b) Replace the text {schema} with {databaseOwner}.
    c) Section 1 can be used for the uninstall script.

*/
/**********************************************************************/

/**********************************************************************/
/*                             BEGIN SECTION 1                        */
/*                                                                    */
/* Drop role, tables, stored procedures, and user-defined functions.  */
/**********************************************************************/

/************************************************************/
/*****                 Drop Database Role               *****/
/************************************************************/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'{objectQualifier}gs_GalleryServerProRole')
DROP SCHEMA [{objectQualifier}gs_GalleryServerProRole]
GO

DECLARE @RoleName sysname
SET @RoleName = N'{objectQualifier}gs_GalleryServerProRole'
IF  EXISTS (SELECT * FROM sys.sysusers WHERE name = @RoleName AND issqlrole = 1)
BEGIN

	DECLARE @RoleMemberName sysname
	DECLARE Member_Cursor CURSOR FOR
	SELECT [name]
	FROM sys.sysusers 
	WHERE uid IN ( 
		SELECT memberuid
		FROM sys.sysmembers
		WHERE groupuid IN (
			SELECT uid
			FROM sys.sysusers WHERE [name] = @RoleName AND issqlrole = 1))

	OPEN Member_Cursor;

	FETCH NEXT FROM Member_Cursor
	INTO @RoleMemberName

	WHILE @@FETCH_STATUS = 0
	BEGIN

		EXEC sp_droprolemember @rolename=@RoleName, @membername= @RoleMemberName

		FETCH NEXT FROM Member_Cursor
		INTO @RoleMemberName
	END;

	CLOSE Member_Cursor;
	DEALLOCATE Member_Cursor;

END
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'{objectQualifier}gs_GalleryServerProRole' AND type = 'R')
DROP ROLE {objectQualifier}gs_GalleryServerProRole
GO

/************************************************************/
/*****            Drop User Defined Functions           *****/
/************************************************************/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_func_convert_string_array_to_table]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION {schema}[{objectQualifier}gs_func_convert_string_array_to_table]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_GetVersion]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION {schema}[{objectQualifier}gs_GetVersion]
GO

/************************************************************/
/*****           Drop Stored Procedures                 *****/
/************************************************************/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_RoleUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_RoleUpdate]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppErrorSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_AppErrorSelect]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppErrorInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_AppErrorInsert]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppErrorDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_AppErrorDelete]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppErrorDeleteAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_AppErrorDeleteAll]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SelectRootAlbum]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_SelectRootAlbum]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectInsert]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SelectChildMediaObjects]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_SelectChildMediaObjects]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectUpdate]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_RoleInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_RoleInsert]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_RoleSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_RoleSelect]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AlbumUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_AlbumUpdate]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AlbumSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_AlbumSelect]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_GallerySelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_GallerySelect]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectSelect]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AlbumInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_AlbumInsert]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_AlbumDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_Role_AlbumDelete]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_AlbumInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_Role_AlbumInsert]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_RoleDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_RoleDelete]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_AlbumSelectAllAlbumsByRoleName]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_Role_AlbumSelectAllAlbumsByRoleName]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_AlbumSelectRootAlbumsByRoleName]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_Role_AlbumSelectRootAlbumsByRoleName]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SynchronizeSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_SynchronizeSelect]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SynchronizeSave]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_SynchronizeSave]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_VerifyMinimumRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_VerifyMinimumRecords]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataSelect]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataInsert]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataDeleteByMediaObjectId]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataDeleteByMediaObjectId]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataUpdate]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataDelete]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SearchGallery]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_SearchGallery]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectSelectHashKeys]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectSelectHashKeys]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SelectChildAlbums]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_SelectChildAlbums]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_MediaObjectDelete]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AlbumDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_AlbumDelete]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_ExportMembership]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_ExportMembership]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_ExportGalleryData]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_ExportGalleryData]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_DeleteData]') AND type in (N'P', N'PC'))
DROP PROCEDURE {schema}[{objectQualifier}gs_DeleteData]
GO

/************************************************************/
/*****       Drop Table Indexes and Constraints         *****/
/************************************************************/

/* Indexes */
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]') AND name = N'IDX_{objectQualifier}gs_Album_AlbumParentId_FKGalleryId')
DROP INDEX [IDX_{objectQualifier}gs_Album_AlbumParentId_FKGalleryId] ON {schema}[{objectQualifier}gs_Album] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppError]') AND name = N'IDX_{objectQualifier}gs_AppError_FKGalleryId')
DROP INDEX [IDX_{objectQualifier}gs_AppError_FKGalleryId] ON {schema}[{objectQualifier}gs_AppError] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]') AND name = N'IDX_{objectQualifier}gs_MediaObject_FKAlbumId')
DROP INDEX [IDX_{objectQualifier}gs_MediaObject_FKAlbumId] ON {schema}[{objectQualifier}gs_MediaObject] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadata]') AND name = N'IDX_{objectQualifier}gs_MediaObjectMetadata_FKMediaObjectId')
DROP INDEX [IDX_{objectQualifier}gs_MediaObjectMetadata_FKMediaObjectId] ON {schema}[{objectQualifier}gs_MediaObjectMetadata] WITH ( ONLINE = OFF )
GO

/* Foreign Keys */
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[FK_{objectQualifier}gs_Album_gs_Album]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Album] DROP CONSTRAINT [FK_{objectQualifier}gs_Album_gs_Album]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[FK_{objectQualifier}gs_Album_gs_Gallery]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Album] DROP CONSTRAINT [FK_{objectQualifier}gs_Album_gs_Gallery]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[FK_{objectQualifier}gs_MediaObject_gs_Album]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [FK_{objectQualifier}gs_MediaObject_gs_Album]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[FK_{objectQualifier}gs_MediaObjectMetadata_gs_MediaObject]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadata]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObjectMetadata] DROP CONSTRAINT [FK_{objectQualifier}gs_MediaObjectMetadata_gs_MediaObject]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[FK_{objectQualifier}gs_Role_Album_gs_Album]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Role_Album] DROP CONSTRAINT [FK_{objectQualifier}gs_Role_Album_gs_Album]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[FK_{objectQualifier}gs_AppError_gs_Gallery]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppError]'))
ALTER TABLE {schema}[{objectQualifier}gs_AppError] DROP CONSTRAINT [FK_{objectQualifier}gs_AppError_gs_Gallery]
GO

/* Primary Keys */
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]') AND name = N'PK_{objectQualifier}gs_Album')
ALTER TABLE {schema}[{objectQualifier}gs_Album] DROP CONSTRAINT [PK_{objectQualifier}gs_Album]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppError]') AND name = N'PK_{objectQualifier}gs_AppError')
ALTER TABLE {schema}[{objectQualifier}gs_AppError] DROP CONSTRAINT [PK_{objectQualifier}gs_AppError]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Gallery]') AND name = N'PK_{objectQualifier}gs_Gallery')
ALTER TABLE {schema}[{objectQualifier}gs_Gallery] DROP CONSTRAINT [PK_{objectQualifier}gs_Gallery]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]') AND name = N'PK_{objectQualifier}gs_MediaObject')
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [PK_{objectQualifier}gs_MediaObject]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadata]') AND name = N'PK_{objectQualifier}gs_MediaObjectMetadata')
ALTER TABLE {schema}[{objectQualifier}gs_MediaObjectMetadata] DROP CONSTRAINT [PK_{objectQualifier}gs_MediaObjectMetadata]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role]') AND name = N'PK_{objectQualifier}gs_Roles')
ALTER TABLE {schema}[{objectQualifier}gs_Role] DROP CONSTRAINT [PK_{objectQualifier}gs_Roles]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_Album]') AND name = N'PK_{objectQualifier}gs_Role_Album')
ALTER TABLE {schema}[{objectQualifier}gs_Role_Album] DROP CONSTRAINT [PK_{objectQualifier}gs_Role_Album]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Synchronize]') AND name = N'PK_{objectQualifier}gs_Synchronize')
ALTER TABLE {schema}[{objectQualifier}gs_Synchronize] DROP CONSTRAINT [PK_{objectQualifier}gs_Synchronize]
GO
IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_Title]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Album] DROP CONSTRAINT [DF_{objectQualifier}gs_Album_Title]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_DirectoryName]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Album] DROP CONSTRAINT [DF_{objectQualifier}gs_Album_DirectoryName]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_Summary]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Album] DROP CONSTRAINT [DF_{objectQualifier}gs_Album_Summary]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_ThumbnailMediaObjectId]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Album] DROP CONSTRAINT [DF_{objectQualifier}gs_Album_ThumbnailMediaObjectId]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_IsPrivate]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Album] DROP CONSTRAINT [DF_{objectQualifier}gs_Album_IsPrivate]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_Title]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_Title]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_HashKey]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_HashKey]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_ThumbnailFilename]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_ThumbnailFilename]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_ThumbnailWidth]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_ThumbnailWidth]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_ThumbnailHeight]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_ThumbnailHeight]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OptimizedFilename]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OptimizedFilename]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OptimizedWidth]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OptimizedWidth]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OptimizedHeight]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OptimizedHeight]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OriginalFilename]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OriginalFilename]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OriginalWidth]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OriginalWidth]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OriginalHeight]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OriginalHeight]
GO

IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_IsPrivate]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] DROP CONSTRAINT [DF_{objectQualifier}gs_MediaObject_IsPrivate]
GO

/************************************************************/
/*****                    Drop Tables                   *****/
/************************************************************/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadata]') AND type in (N'U'))
DROP TABLE {schema}[{objectQualifier}gs_MediaObjectMetadata]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_Album]') AND type in (N'U'))
DROP TABLE {schema}[{objectQualifier}gs_Role_Album]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]') AND type in (N'U'))
DROP TABLE {schema}[{objectQualifier}gs_MediaObject]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]') AND type in (N'U'))
DROP TABLE {schema}[{objectQualifier}gs_Album]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role]') AND type in (N'U'))
DROP TABLE {schema}[{objectQualifier}gs_Role]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Synchronize]') AND type in (N'U'))
DROP TABLE {schema}[{objectQualifier}gs_Synchronize]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Gallery]') AND type in (N'U'))
DROP TABLE {schema}[{objectQualifier}gs_Gallery]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppError]') AND type in (N'U'))
DROP TABLE {schema}[{objectQualifier}gs_AppError]
GO

/**********************************************************************/
/*                             END SECTION 1                          */
/**********************************************************************/

/**********************************************************************/
/*                             BEGIN SECTION 2                        */
/*                                                                    */
/* Create role, tables, stored procedures, and user-defined functions.*/
/**********************************************************************/

/****** Object:  Table [gs_Gallery]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Gallery]') AND type in (N'U'))
BEGIN
CREATE TABLE {schema}[{objectQualifier}gs_Gallery](
	[GalleryId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[DateAdded] [datetime] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}gs_Gallery] PRIMARY KEY CLUSTERED 
(
	[GalleryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
/****** Object:  Table [gs_Synchronize] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Synchronize]') AND type in (N'U'))
BEGIN
CREATE TABLE {schema}[{objectQualifier}gs_Synchronize](
	[SynchId] [nchar](50) NOT NULL,
	[FKGalleryId] [int] NOT NULL,
	[SynchState] [int] NOT NULL,
	[TotalFiles] [int] NOT NULL,
	[CurrentFileIndex] [int] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}gs_Synchronize] PRIMARY KEY CLUSTERED 
(
	[SynchId] ASC,
	[FKGalleryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
/****** Object:  StoredProcedure [gs_AlbumDelete] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AlbumDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_AlbumDelete]
	@AlbumId int
AS
SET NOCOUNT ON
/* Delete the specified album and its objects, including any child albums.  Instead of using 
built-in cascading delete features of the database, we delete all objects manually. This is
primarily because SQL Server does not support cascade delete for hierarchal tables, which is
how album data is stored (the AlbumParentId field refers to the AlbumId field).*/

/* First, build a table containing this album ID and all child album IDs. */
CREATE TABLE #a (aid int, apid int, processed int)

/* Insert this album into our temporary table. */
INSERT #a 
	SELECT AlbumId, AlbumParentId, 0
	FROM {schema}[{objectQualifier}gs_Album] WHERE AlbumId = @AlbumId

/* Set up a loop where we insert the children of the first album, and their children, and so on, until no 
children are left. The end result is that the table is filled with info about @AlbumId and all his descendents.
The processed field in #a represents the # of levels from the bottom. Thus the records
with the MAX processed value is @AlbumId, and the records with the MIN level (should always be 1)
represent the most distant descendents. */
WHILE EXISTS (SELECT * FROM #a WHERE processed = 0)
BEGIN
	/* Insert the children of all albums in #a into the table. We use the ''processed = 0'' criterion because we
	only want to get the children once. Each loop increases the value of the processed field by one.  */
	INSERT #a SELECT AlbumId, AlbumParentId, -1
		FROM {schema}[{objectQualifier}gs_Album] WHERE AlbumParentId IN 
			(SELECT aid FROM #a WHERE processed = 0)
	
	/* Increment the processed value to preserve the heiarchy of albums. */
	UPDATE #a SET processed = processed + 1
END

/* At this point #a contains info about @AlbumId and all his descendents. Delete all media objects 
and roles associated with these albums, and then delete the albums. */
BEGIN TRAN
	DELETE {schema}[{objectQualifier}gs_MediaObject] WHERE FKAlbumId IN (SELECT aid FROM #a)
	
	DELETE {schema}[{objectQualifier}gs_Role_Album] WHERE FKAlbumId IN (SELECT aid FROM #a)
	
	/* Only delete albums that are not the root album (apid <> 0). */
	DELETE {schema}[{objectQualifier}gs_Album] WHERE AlbumId IN (SELECT aid FROM #a WHERE apid <> 0)
COMMIT TRAN' 
END
GO
/****** Object:  StoredProcedure [gs_ExportMembership] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_ExportMembership]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_ExportMembership]
AS
SET NOCOUNT ON

SELECT ApplicationName, LoweredApplicationName, ApplicationId, Description
FROM aspnet_Applications

SELECT ApplicationId, UserId, Password, PasswordFormat, PasswordSalt, MobilePIN, Email, LoweredEmail, PasswordQuestion, PasswordAnswer, IsApproved, 
 IsLockedOut, CreateDate, LastLoginDate, LastPasswordChangedDate, LastLockoutDate, FailedPasswordAttemptCount, FailedPasswordAttemptWindowStart, 
 FailedPasswordAnswerAttemptCount, FailedPasswordAnswerAttemptWindowStart, Comment
FROM aspnet_Membership

SELECT UserId, PropertyNames, PropertyValuesString, PropertyValuesBinary, LastUpdatedDate
FROM aspnet_Profile

SELECT ApplicationId, RoleId, RoleName, LoweredRoleName, Description
FROM aspnet_Roles

SELECT ApplicationId, UserId, UserName, LoweredUserName, MobileAlias, IsAnonymous, LastActivityDate
FROM aspnet_Users

SELECT UserId, RoleId
FROM aspnet_UsersInRoles

RETURN' 
END
GO

/****** Object:  StoredProcedure [gs_ExportGalleryData] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_ExportGalleryData]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_ExportGalleryData]
AS
SET NOCOUNT ON

SELECT AlbumId, FKGalleryId, AlbumParentId, Title, DirectoryName, Summary, ThumbnailMediaObjectId, Seq, DateStart, DateEnd, DateAdded, CreatedBy, 
 LastModifiedBy, DateLastModified, OwnedBy, OwnerRoleName, IsPrivate
FROM {schema}[{objectQualifier}gs_Album]

SELECT GalleryId, Description, DateAdded
FROM {schema}[{objectQualifier}gs_Gallery]

SELECT MediaObjectId, FKAlbumId, Title, HashKey, ThumbnailFilename, ThumbnailWidth, ThumbnailHeight, ThumbnailSizeKB, OptimizedFilename, OptimizedWidth, 
 OptimizedHeight, OptimizedSizeKB, OriginalFilename, OriginalWidth, OriginalHeight, OriginalSizeKB, ExternalHtmlSource, ExternalType, Seq, CreatedBy, 
 DateAdded, LastModifiedBy, DateLastModified, IsPrivate
FROM {schema}[{objectQualifier}gs_MediaObject]

SELECT MediaObjectMetadataId, FKMediaObjectId, MetadataNameIdentifier, Description, Value
FROM {schema}[{objectQualifier}gs_MediaObjectMetadata]

SELECT RoleName, FKGalleryId, AllowViewAlbumsAndObjects, AllowViewOriginalImage, AllowAddChildAlbum, AllowAddMediaObject, AllowEditAlbum, 
 AllowEditMediaObject, AllowDeleteChildAlbum, AllowDeleteMediaObject, AllowSynchronize, HideWatermark, AllowAdministerSite
FROM {schema}[{objectQualifier}gs_Role]

SELECT FKRoleName, FKAlbumId
FROM {schema}[{objectQualifier}gs_Role_Album]

SELECT AppErrorId, FKGalleryId, TimeStamp, ExceptionType, Message, Source, TargetSite, StackTrace, ExceptionData, InnerExType, InnerExMessage, InnerExSource, 
 InnerExTargetSite, InnerExStackTrace, InnerExData, Url, FormVariables, Cookies, SessionVariables, ServerVariables
FROM {schema}[{objectQualifier}gs_AppError]

SELECT {schema}[{objectQualifier}gs_GetVersion]() AS SchemaVersion

RETURN' 
END
GO

/****** Object:  StoredProcedure [gs_DeleteData] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_DeleteData]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_DeleteData]
(	@DeleteMembershipData bit, @DeleteGalleryData bit	)

AS
SET NOCOUNT ON

IF @DeleteMembershipData = 1
BEGIN
	DELETE FROM {schema}[{objectQualifier}aspnet_UsersInRoles]
	DELETE FROM {schema}[{objectQualifier}aspnet_Profile]
	DELETE FROM {schema}[{objectQualifier}aspnet_Membership]
	DELETE FROM {schema}[{objectQualifier}aspnet_Users]
	DELETE FROM {schema}[{objectQualifier}aspnet_Roles]
	DELETE FROM {schema}[{objectQualifier}aspnet_Applications]
END

IF @DeleteGalleryData = 1 
BEGIN
	DELETE FROM {schema}[{objectQualifier}gs_MediaObjectMetadata]
	DELETE FROM {schema}[{objectQualifier}gs_MediaObject]
	DELETE FROM {schema}[{objectQualifier}gs_Role]
	DELETE FROM {schema}[{objectQualifier}gs_Role_Album]
	DELETE FROM {schema}[{objectQualifier}gs_Album]
	DELETE FROM {schema}[{objectQualifier}gs_Gallery]
	DELETE FROM {schema}[{objectQualifier}gs_AppError]
END

RETURN' 
END
GO

/****** Object:  StoredProcedure [gs_MediaObjectDelete]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectDelete]
(
	@MediaObjectId int
)
AS
SET NOCOUNT ON
/* Delete the specified media object. */
DELETE {schema}[{objectQualifier}gs_MediaObject]
WHERE MediaObjectId = @MediaObjectId

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_SelectChildAlbums]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SelectChildAlbums]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_SelectChildAlbums]
(
	@AlbumId int, @GalleryId int
)
AS
SET NOCOUNT ON

SELECT AlbumId
FROM {schema}[{objectQualifier}gs_Album]
WHERE AlbumParentId = @AlbumId AND FKGalleryId = @GalleryId

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_MediaObjectSelectHashKeys]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectSelectHashKeys]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectSelectHashKeys]
(
	@GalleryId int
)
AS
SET NOCOUNT ON

SELECT {schema}[{objectQualifier}gs_MediaObject].HashKey
FROM {schema}[{objectQualifier}gs_MediaObject] INNER JOIN {schema}[{objectQualifier}gs_Album] ON {schema}[{objectQualifier}gs_MediaObject].FKAlbumId = {schema}[{objectQualifier}gs_Album].AlbumId
WHERE {schema}[{objectQualifier}gs_Album].FKGalleryId = @GalleryId

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_SearchGallery]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SearchGallery]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_SearchGallery]
(     @SearchTerms nvarchar(4000), @GalleryId int)
AS
SET NOCOUNT ON

/* Search for albums and media objects that match the specified search
terms. The album or media object must match
ALL search terms to be considered a match. There is no ''OR'' capability. For
albums, the Title and Summary columns 
are searched. For media objects, the Title and OriginalFilename columns and
all metadata in the MediaObjectMetadata 
tables is searched.

Inputs:
@SearchTerms - A comma-delimited set of search terms. May include spaces.
Ex: "cat,dog", "cat videos, dog videos"
  Multiple words in a single search term (such as "cat videos" in the
previous example) are treated as a phrase
  that must be matched, exactly like how Google treats phrases contained in
quotation marks. That is, "cat videos"
  requires the phrase "cat videos" to appear somewhere in the data, and it
will not match "cat and dog videos"
  (to match "cat and dog videos", you can use "cat,videos").
@GalleryId - The ID of the gallery to search.

Returns:
Returns a set of records with two columns:
gotype - A single character containing either ''a'' for album or ''m'' for media
object. Indicates whether the id
         stored in the second column is an album or media object.
id - The ID of a matching album or media object.

Algorithm:
The search follows these steps:
1. Create a temporary table #searchTerms and insert the search terms into
it, prepending and appending the wildcard
   character (%). Ex: If @SearchTerms = "cat videos,dog,fish", #searchTerms
will get 3 records: %cat videos%,
   %dog%, %fish%.
2. Create a second temporary table #searchResults to hold intermediate
search results.
3. Insert into #searchResults all albums where the title matches one of more
search terms. There will be one record
   inserted for each matching search term. Ex: If @SearchTerms = "cat
videos,dog,fish" and the album title =
   "My dog and cat videos", there will be two records inserted into
#searchResults, one with matchingSearchTerm =
   "%cat videos%" and the other "%dog%" (gotype=''a'', id=album ID,
fieldname=''Album.Title'' for both).
4. Repeat the above step for other fields: Album.Summary, MediaObject.Title,
MediaObject.OriginalFilename, and
   all media object metadata for each media object
5. Select those records from #searchResults where we made a successful match
for EVERY search term for each album or
   media object.
   
Note: The fieldname column in #searchResults is not used except for manual
debugging purposes. This column can
be removed if desired. 
*/

CREATE TABLE #searchTerms (searchTerm nvarchar(4000) COLLATE database_default)
CREATE TABLE #searchResults (
      gotype char(1), 
      id int, 
      fieldname nvarchar(50) COLLATE database_default, 
      matchingSearchTerm nvarchar(3000) COLLATE database_default)

INSERT #searchTerms
SELECT ''%'' + nstr + ''%'' FROM
{schema}[{objectQualifier}gs_func_convert_string_array_to_table](@SearchTerms, '','')

-- Search album title
INSERT #searchResults
SELECT ''a'', a.AlbumId, ''Album.Title'', ''%'' + SUBSTRING(a.Title,
PATINDEX(#searchTerms.searchTerm, a.Title),
LEN(#searchTerms.searchTerm) - 2) + ''%''
 FROM {schema}[{objectQualifier}gs_Album] a CROSS JOIN #searchTerms
 WHERE a.FKGalleryId = @GalleryId AND a.Title LIKE #searchTerms.searchTerm

-- Search album summary
INSERT #searchResults
SELECT ''a'', a.AlbumId, ''Album.Summary'', ''%'' + SUBSTRING(a.Summary,
PATINDEX(#searchTerms.searchTerm, a.Summary), LEN(#searchTerms.searchTerm) -
2) + ''%''
 FROM {schema}[{objectQualifier}gs_Album] a CROSS JOIN #searchTerms
 WHERE a.FKGalleryId = @GalleryId AND a.Summary LIKE #searchTerms.searchTerm

-- Search media object title
INSERT #searchResults
SELECT ''m'', m.MediaObjectId, ''MediaObject.Title'', ''%'' +
SUBSTRING(m.Title, PATINDEX(#searchTerms.searchTerm,
m.Title), LEN(#searchTerms.searchTerm) - 2) + ''%''
 FROM {schema}[{objectQualifier}gs_MediaObject] m JOIN {schema}[{objectQualifier}gs_Album] a
 ON a.AlbumId = m.FKAlbumId CROSS JOIN #searchTerms
 WHERE a.FKGalleryId = @GalleryId AND m.Title LIKE
#searchTerms.searchTerm

-- Search media object original filename
INSERT #searchResults
SELECT ''m'', m.MediaObjectId, ''MediaObject.OriginalFilename'',
''%'' + SUBSTRING(m.OriginalFilename,
PATINDEX(#searchTerms.searchTerm, m.OriginalFilename),
LEN(#searchTerms.searchTerm) - 2) + ''%''
 FROM {schema}[{objectQualifier}gs_MediaObject] m JOIN {schema}[{objectQualifier}gs_Album] a ON a.AlbumId =
m.FKAlbumId CROSS JOIN #searchTerms
 WHERE a.FKGalleryId = @GalleryId AND m.OriginalFilename
LIKE #searchTerms.searchTerm --AND 0=1

-- Search media object metadata
INSERT #searchResults
SELECT DISTINCT ''m'', m.MediaObjectId, ''MediaObjectMetadata'',
''%'' + SUBSTRING(md.Value,
PATINDEX(#searchTerms.searchTerm, md.Value),
LEN(#searchTerms.searchTerm) - 2) + ''%''
 FROM {schema}[{objectQualifier}gs_MediaObjectMetadata] md JOIN {schema}[{objectQualifier}gs_MediaObject] m
 ON md.FKMediaObjectId = m.MediaObjectId
JOIN {schema}[{objectQualifier}gs_Album] a
 ON a.AlbumId = m.FKAlbumId CROSS JOIN #searchTerms
 WHERE a.FKGalleryId = @GalleryId AND md.Value
LIKE #searchTerms.searchTerm

-- Uncomment for debug purposes:
--SELECT * from #searchTerms
--SELECT * FROM #searchResults

SELECT sr.gotype, sr.id
FROM #searchTerms AS st INNER JOIN (SELECT DISTINCT gotype, id,
matchingSearchTerm FROM #searchResults) AS sr ON st.searchTerm =
sr.matchingSearchTerm
GROUP BY sr.gotype, sr.id
HAVING (COUNT(*) >= (SELECT COUNT(*) FROM #searchTerms))

RETURN
' 
END
GO
/****** Object:  Table [gs_Role]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role]') AND type in (N'U'))
BEGIN
CREATE TABLE {schema}[{objectQualifier}gs_Role](
	[RoleName] [nvarchar](256) NOT NULL,
	[FKGalleryId] [int] NOT NULL,
	[AllowViewAlbumsAndObjects] [bit] NOT NULL,
	[AllowViewOriginalImage] [bit] NOT NULL,
	[AllowAddChildAlbum] [bit] NOT NULL,
	[AllowAddMediaObject] [bit] NOT NULL,
	[AllowEditAlbum] [bit] NOT NULL,
	[AllowEditMediaObject] [bit] NOT NULL,
	[AllowDeleteChildAlbum] [bit] NOT NULL,
	[AllowDeleteMediaObject] [bit] NOT NULL,
	[AllowSynchronize] [bit] NOT NULL,
	[HideWatermark] [bit] NOT NULL,
	[AllowAdministerSite] [bit] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}gs_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleName] ASC,
	[FKGalleryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
/****** Object:  UserDefinedFunction [gs_func_convert_string_array_to_table]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_func_convert_string_array_to_table]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute sp_executesql @statement = N'CREATE FUNCTION {schema}[{objectQualifier}gs_func_convert_string_array_to_table]
                 (@list      nvarchar(MAX),
                  @delimiter nchar(1) = N'','')
      RETURNS @tbl TABLE (listpos int IDENTITY(1, 1) NOT NULL,
                          str     varchar(4000) COLLATE database_default NOT NULL,
                          nstr    nvarchar(2000) COLLATE database_default NOT NULL) AS

BEGIN
   DECLARE @endpos   int,
           @startpos int,
           @textpos  int,
           @chunklen smallint,
           @tmpstr   nvarchar(4000),
           @leftover nvarchar(4000),
           @tmpval   nvarchar(4000)

   SET @textpos = 1
   SET @leftover = ''''
   WHILE @textpos <= datalength(@list) / 2
   BEGIN
      SET @chunklen = 4000 - datalength(@leftover) / 2
      SET @tmpstr = @leftover + substring(@list, @textpos, @chunklen)
      SET @textpos = @textpos + @chunklen

      SET @startpos = 0
      SET @endpos = charindex(@delimiter, @tmpstr)

      WHILE @endpos > 0
      BEGIN
         SET @tmpval = ltrim(rtrim(substring(@tmpstr, @startpos + 1,
                                             @endpos - @startpos - 1)))
         INSERT @tbl (str, nstr) VALUES(@tmpval, @tmpval)
         SET @startpos = @endpos
         SET @endpos = charindex(@delimiter,
                                 @tmpstr, @startpos + 1)
      END

      SET @leftover = right(@tmpstr, datalength(@tmpstr) / 2 - @startpos)
   END

   INSERT @tbl(str, nstr)
      VALUES (ltrim(rtrim(@leftover)), ltrim(rtrim(@leftover)))
   RETURN
END' 
END
GO
/****** Object:  UserDefinedFunction [gs_GetVersion] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_GetVersion]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute sp_executesql @statement = N'CREATE FUNCTION {schema}[{objectQualifier}gs_GetVersion]()
RETURNS
   VARCHAR(255)
AS
BEGIN
   RETURN ''2.3.3421''
END' 
END
GO
/****** Object:  Table [gs_Album]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]') AND type in (N'U'))
BEGIN
CREATE TABLE {schema}[{objectQualifier}gs_Album](
	[AlbumId] [int] IDENTITY(1,1) NOT NULL,
	[FKGalleryId] [int] NOT NULL,
	[AlbumParentId] [int] NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[DirectoryName] [nvarchar](255) NOT NULL,
	[Summary] [nvarchar](1500) NOT NULL,
	[ThumbnailMediaObjectId] [int] NOT NULL,
	[Seq] [int] NOT NULL,
	[DateStart] [datetime] NULL,
	[DateEnd] [datetime] NULL,
	[DateAdded] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[LastModifiedBy] [nvarchar](256) NOT NULL,
	[DateLastModified] [datetime] NOT NULL,
	[OwnedBy] [nvarchar](256) NOT NULL,
	[OwnerRoleName] [nvarchar](256) NOT NULL,
	[IsPrivate] [bit] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}gs_Album] PRIMARY KEY CLUSTERED 
(
	[AlbumId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
/****** Object:  Non-clustered index [IDX_gs_Album_AlbumParentId_FKGalleryId] ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]') AND name = N'IDX_{objectQualifier}gs_Album_AlbumParentId_FKGalleryId')
	CREATE NONCLUSTERED INDEX [IDX_{objectQualifier}gs_Album_AlbumParentId_FKGalleryId] ON {schema}[{objectQualifier}gs_Album] 
	(
		[AlbumParentId] ASC,
		[FKGalleryId] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
GO
/****** Object:  Table [gs_MediaObject]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]') AND type in (N'U'))
BEGIN
CREATE TABLE {schema}[{objectQualifier}gs_MediaObject](
	[MediaObjectId] [int] IDENTITY(1,1) NOT NULL,
	[FKAlbumId] [int] NOT NULL,
	[Title] [nvarchar](1000) NOT NULL,
	[HashKey] [nchar](47) NOT NULL,
	[ThumbnailFilename] [nvarchar](255) NOT NULL,
	[ThumbnailWidth] [int] NOT NULL,
	[ThumbnailHeight] [int] NOT NULL,
	[ThumbnailSizeKB] [int] NOT NULL,
	[OptimizedFilename] [nvarchar](255) NOT NULL,
	[OptimizedWidth] [int] NOT NULL,
	[OptimizedHeight] [int] NOT NULL,
	[OptimizedSizeKB] [int] NOT NULL,
	[OriginalFilename] [nvarchar](255) NOT NULL,
	[OriginalWidth] [int] NOT NULL,
	[OriginalHeight] [int] NOT NULL,
	[OriginalSizeKB] [int] NOT NULL,
	[ExternalHtmlSource] [nvarchar](1000) NOT NULL,
	[ExternalType] [nvarchar](15) NOT NULL,
	[Seq] [int] NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[DateAdded] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](256) NOT NULL,
	[DateLastModified] [datetime] NOT NULL,
	[IsPrivate] [bit] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}gs_MediaObject] PRIMARY KEY CLUSTERED 
(
	[MediaObjectId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
/****** Object:  Non-clustered index [IDX_gs_MediaObject_FKAlbumId]  ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]') AND name = N'IDX_{objectQualifier}gs_MediaObject_FKAlbumId')
	CREATE NONCLUSTERED INDEX [IDX_{objectQualifier}gs_MediaObject_FKAlbumId] ON {schema}[{objectQualifier}gs_MediaObject] ([FKAlbumId] ASC)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
GO
/****** Object:  Table [gs_Role_Album]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_Album]') AND type in (N'U'))
BEGIN
CREATE TABLE {schema}[{objectQualifier}gs_Role_Album](
	[FKRoleName] [nvarchar](256) NOT NULL,
	[FKAlbumId] [int] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}gs_Role_Album] PRIMARY KEY CLUSTERED 
(
	[FKRoleName] ASC,
	[FKAlbumId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
/****** Object:  Table [gs_MediaObjectMetadata]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadata]') AND type in (N'U'))
BEGIN
CREATE TABLE {schema}[{objectQualifier}gs_MediaObjectMetadata](
	[MediaObjectMetadataId] [int] IDENTITY(1,1) NOT NULL,
	[FKMediaObjectId] [int] NOT NULL,
	[MetadataNameIdentifier] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_{objectQualifier}gs_MediaObjectMetadata] PRIMARY KEY CLUSTERED 
(
	[MediaObjectMetadataId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
/****** Object:  Non-clustered index [IDX_gs_MediaObjectMetadata_FKMediaObjectId]  ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadata]') AND name = N'IDX_{objectQualifier}gs_MediaObjectMetadata_FKMediaObjectId')
	CREATE NONCLUSTERED INDEX [IDX_{objectQualifier}gs_MediaObjectMetadata_FKMediaObjectId] ON {schema}[{objectQualifier}gs_MediaObjectMetadata] ([FKMediaObjectId] ASC )
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
GO
/****** Object:  Table [gs_AppError] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppError]') AND type in (N'U'))
BEGIN
CREATE TABLE {schema}[{objectQualifier}gs_AppError] (
	[AppErrorId] [int] IDENTITY(1,1) NOT NULL,
	[FKGalleryId] [int] NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[ExceptionType] [nvarchar] (1000) NOT NULL,
	[Message] [nvarchar] (4000) NOT NULL,
	[Source] [nvarchar] (1000) NOT NULL,
	[TargetSite] [nvarchar] (max) NOT NULL,
	[StackTrace] [nvarchar] (max) NOT NULL,
	[ExceptionData] [nvarchar] (max) NOT NULL,
	[InnerExType] [nvarchar] (1000) NOT NULL,
	[InnerExMessage] [nvarchar] (4000) NOT NULL,
	[InnerExSource] [nvarchar] (1000) NOT NULL,
	[InnerExTargetSite] [nvarchar] (max) NOT NULL,
	[InnerExStackTrace] [nvarchar] (max) NOT NULL,
	[InnerExData] [nvarchar] (max) NOT NULL,
	[Url] [nvarchar] (1000) NOT NULL,
	[FormVariables] [nvarchar] (max) NOT NULL,
	[Cookies] [nvarchar] (max) NOT NULL,
	[SessionVariables] [nvarchar] (max) NOT NULL,
	[ServerVariables] [nvarchar] (max) NOT NULL
 CONSTRAINT [PK_{objectQualifier}gs_AppError] PRIMARY KEY CLUSTERED 
(
	[AppErrorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
/****** Object:  Non-clustered index [IDX_gs_AppError_FKGalleryId]  ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppError]') AND name = N'IDX_{objectQualifier}gs_AppError_FKGalleryId')
	CREATE NONCLUSTERED INDEX [IDX_{objectQualifier}gs_AppError_FKGalleryId] ON {schema}[{objectQualifier}gs_AppError] ([FKGalleryId] ASC )
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
GO
/****** Object:  StoredProcedure [gs_MediaObjectMetadataDelete]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataDelete]
( @MediaObjectMetadataId int )
AS
/* Delete a new media object meta data item */
DELETE {schema}[{objectQualifier}gs_MediaObjectMetadata]
WHERE MediaObjectMetadataId = @MediaObjectMetadataId' 
END
GO
/****** Object:  StoredProcedure [gs_MediaObjectMetadataUpdate]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataUpdate]
(@FKMediaObjectId int, @MetadataNameIdentifier int, @Description nvarchar(100), @Value nvarchar(2000),
 @MediaObjectMetadataId int)
AS
/* Update a new media object meta data item */
UPDATE {schema}[{objectQualifier}gs_MediaObjectMetadata]
SET FKMediaObjectId = @FKMediaObjectId,
 MetadataNameIdentifier = @MetadataNameIdentifier,
 Description = @Description,
 Value = @Value
WHERE MediaObjectMetadataId = @MediaObjectMetadataId' 
END
GO
/****** Object:  StoredProcedure [gs_MediaObjectMetadataDeleteByMediaObjectId]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataDeleteByMediaObjectId]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataDeleteByMediaObjectId]
( @MediaObjectId int )
AS
/* Delete all new metadata items belonging to the specified media object ID. */
DELETE {schema}[{objectQualifier}gs_MediaObjectMetadata]
WHERE FKMediaObjectId = @MediaObjectId' 
END
GO
/****** Object:  StoredProcedure [gs_MediaObjectMetadataInsert] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataInsert]
(@FKMediaObjectId int, @MetadataNameIdentifier int, @Description nvarchar(100), @Value nvarchar(2000),
 @Identity int OUT)
AS
/* Insert a new media object meta data item */
INSERT {schema}[{objectQualifier}gs_MediaObjectMetadata] (FKMediaObjectId, MetadataNameIdentifier, Description, Value)
VALUES (@FKMediaObjectId, @MetadataNameIdentifier, @Description, @Value)

SET @Identity = SCOPE_IDENTITY()' 
END
GO
/****** Object:  StoredProcedure [gs_MediaObjectMetadataSelect]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadataSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectMetadataSelect]
(
	@MediaObjectId int, @GalleryId int
)
AS
SET NOCOUNT ON

SELECT
	md.MediaObjectMetadataId, md.FKMediaObjectId, md.MetadataNameIdentifier, md.Description, md.Value
FROM {schema}[{objectQualifier}gs_MediaObjectMetadata] md JOIN {schema}[{objectQualifier}gs_MediaObject] mo ON md.FKMediaObjectId = mo.MediaObjectId
	JOIN {schema}[{objectQualifier}gs_Album] a ON mo.FKAlbumId = a.AlbumId
WHERE md.FKMediaObjectId = @MediaObjectId AND a.FKGalleryId = @GalleryId

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_VerifyMinimumRecords]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_VerifyMinimumRecords]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_VerifyMinimumRecords]
(
	@GalleryId int
)
AS
SET NOCOUNT ON
/* Verify that certain tables have the required records, inserting them if necessary. This proc is designed 
to be run each time the application starts. This proc is especially important the first time Gallery Server 
is run as Gallery Server depends on this proc to install the default set of data.

Gallery: This table requires at least one record to represent the current gallery. If no records are
			found, one is inserted with a ID equal to the @GalleryId parameter.
Album: This table requires at least one record to represent the root album. If no records are found, 
       a new record representing the root album is added.
Synchronize: This table requires one record for each gallery. It stores the current state of a synchronization,
			if one is in progress. When a synchronization is not in progress, the SynchState field should be zero
			for this gallery.
*/

/* ******************************************************* */
--          Check the Gallery table
/* ******************************************************* */
BEGIN TRAN
IF NOT EXISTS (SELECT * FROM {schema}[{objectQualifier}gs_Gallery] WITH (UPDLOCK, HOLDLOCK) WHERE GalleryId = @GalleryId)
BEGIN
	INSERT {schema}[{objectQualifier}gs_Gallery] (GalleryId, Description, DateAdded)
	VALUES (@GalleryId, ''My Gallery'', GETDATE())
END
COMMIT

/* ******************************************************* */
--          Check the Album table
/* ******************************************************* */
BEGIN TRAN
IF NOT EXISTS (SELECT * FROM {schema}[{objectQualifier}gs_Album] WITH (UPDLOCK, HOLDLOCK) WHERE AlbumParentId = 0 AND FKGalleryId = @GalleryId)
BEGIN
  /* The album table does not have a root album for the specified gallery. Insert one. */
  INSERT {schema}[{objectQualifier}gs_Album] (AlbumParentId, FKGalleryId, Title, DirectoryName, Summary, ThumbnailMediaObjectId, Seq, CreatedBy, DateAdded, LastModifiedBy, DateLastModified, OwnedBy, OwnerRoleName, IsPrivate)
  VALUES (0, @GalleryId, ''All albums'', '''',''Welcome to Gallery Server Pro!'', 0, 0, ''System'', GETDATE(), ''System'', GETDATE(), '''', '''', 0)
END 
COMMIT

/* ******************************************************* */
--          Check the Synchronize table
/* ******************************************************* */
BEGIN TRAN
IF EXISTS (SELECT * FROM {schema}[{objectQualifier}gs_Synchronize] WITH (UPDLOCK, HOLDLOCK) WHERE FKGalleryId = @GalleryId)
BEGIN -- Reset record to clear out any previous synchronization
	UPDATE {schema}[{objectQualifier}gs_Synchronize]
	SET SynchId = '''',
	SynchState = 0,
	TotalFiles = 0,
	CurrentFileIndex = 0
	WHERE FKGalleryId = @GalleryId
END
ELSE
BEGIN
	INSERT INTO {schema}[{objectQualifier}gs_Synchronize] (SynchId, FKGalleryId, SynchState, TotalFiles, CurrentFileIndex)
	VALUES ('''',@GalleryId, 0, 0, 0)
END
COMMIT

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_SynchronizeSave]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SynchronizeSave]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_SynchronizeSave]
	(@SynchId nchar(50), @GalleryId int, @SynchState int, @TotalFiles int, @CurrentFileIndex int)
AS
SET NOCOUNT, XACT_ABORT ON
/* UPDATE the synchronize table with the specified data. */

/* Check if another synchronization is in progress. Return with error code if it is. */
IF EXISTS (SELECT * FROM {schema}[{objectQualifier}gs_Synchronize] WHERE FKGalleryId = @GalleryId AND SynchId <> @SynchId AND (SynchState = 1 OR SynchState = 2))
BEGIN
	RETURN 250000
END

BEGIN TRAN
IF EXISTS (SELECT * FROM {schema}[{objectQualifier}gs_Synchronize] WITH (UPDLOCK, HOLDLOCK) WHERE FKGalleryId = @GalleryId)
	UPDATE {schema}[{objectQualifier}gs_Synchronize]
	SET SynchId = @SynchId,
		FKGalleryId = @GalleryId,
		SynchState = @SynchState,
		TotalFiles = @TotalFiles,
		CurrentFileIndex = @CurrentFileIndex
	WHERE FKGalleryId = @GalleryId
ELSE
	INSERT {schema}[{objectQualifier}gs_Synchronize] (SynchId, FKGalleryId, SynchState, TotalFiles, CurrentFileIndex)
	VALUES (@SynchId, @GalleryId, @SynchState, @TotalFiles, @CurrentFileIndex)
COMMIT
	
RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_SynchronizeSelect] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SynchronizeSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_SynchronizeSelect]
(@GalleryId int)
AS
SET NOCOUNT ON

/* Return the synchronize data for the specified gallery. It should contain 1 record. */
SELECT SynchId, FKGalleryId, SynchState, TotalFiles, CurrentFileIndex
FROM {schema}[{objectQualifier}gs_Synchronize]
WHERE FKGalleryId = @GalleryId

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_Role_AlbumSelectRootAlbumsByRoleName]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_AlbumSelectRootAlbumsByRoleName]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_Role_AlbumSelectRootAlbumsByRoleName]
(	@RoleName nvarchar(256), @GalleryId int )

AS
SET NOCOUNT ON

SELECT ra.FKAlbumId
FROM {schema}[{objectQualifier}gs_Role_Album] ra INNER JOIN {schema}[{objectQualifier}gs_Album] a ON ra.FKAlbumId = a.AlbumId
WHERE (ra.FKRoleName = @RoleName) AND (a.FKGalleryId = @GalleryId)

RETURN
' 
END
GO
/****** Object:  StoredProcedure [gs_Role_AlbumSelectAllAlbumsByRoleName]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_AlbumSelectAllAlbumsByRoleName]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_Role_AlbumSelectAllAlbumsByRoleName]
(	@RoleName nvarchar(256), @GalleryId int )

AS
SET NOCOUNT ON

/* Retrieve all the album IDs that are affected by the specified role name. The album IDs that are stored in
   the gs_Role_Album table only hold the highest ranking album ID. */
   
/* If the role is applied to the root album, then we can just return all albums in the gallery. This is 
much cheaper than drilling down by album.  */
DECLARE @RootAlbumId int
SELECT @RootAlbumId = AlbumId FROM {schema}[{objectQualifier}gs_Album] WHERE AlbumParentId = 0 AND FKGalleryId = @GalleryId
 
IF EXISTS (SELECT * FROM {schema}[{objectQualifier}gs_Role_Album] WHERE FKRoleName = @RoleName AND FKAlbumId = @RootAlbumId)
BEGIN
	SELECT AlbumId FROM {schema}[{objectQualifier}gs_Album] WHERE FKGalleryId = @GalleryId
END
ELSE
BEGIN
	/* The role applies to an album or albums below the root album, so we need to drill down and retrieve all
   the children. Start by creating a temporary table to hold our data. */
	DECLARE @AlbumList table
		(AlbumId int not null,
		AlbumParentId int not null,
		AlbumDepth int not null)

	/* Insert the top level album IDs. */
	INSERT @AlbumList (AlbumId, AlbumParentId, AlbumDepth)
	SELECT FKAlbumId, 0, 1
	FROM {schema}[{objectQualifier}gs_Role_Album] ra INNER JOIN {schema}[{objectQualifier}gs_Album] a ON ra.FKAlbumId = a.AlbumId
	WHERE (ra.FKRoleName = @RoleName) AND (a.FKGalleryId = @GalleryId)

	/* Continue drilling down, level by level, until we reach a level where there are no more child albums. */
	WHILE (@@rowcount > 0) BEGIN
		INSERT @AlbumList (AlbumId, AlbumParentId, AlbumDepth)
		SELECT a.AlbumId, a.AlbumParentId, al.AlbumDepth + 1
		FROM {schema}[{objectQualifier}gs_Album] a JOIN @AlbumList al ON a.AlbumParentId = al.AlbumId
		WHERE al.AlbumDepth = (SELECT MAX(AlbumDepth) FROM @AlbumList)
	END

	/* Retrieve the list of album IDs. */
	SELECT AlbumId
	FROM @AlbumList
END

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_RoleDelete]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_RoleDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_RoleDelete]
( @GalleryId int, @RoleName nvarchar(256) )
AS
/* Delete a gallery server role. This procedure only deletes it from the custom gallery server tables,
not the ASP.NET role membership table(s). The web application code that invokes this procedure also
uses the standard ASP.NET technique to delete the role from the membership table(s). */

-- First delete the records from the role/album association table.
DELETE {schema}[{objectQualifier}gs_Role_Album]
WHERE FKRoleName = @RoleName

-- Finally delete the role.
DELETE {schema}[{objectQualifier}gs_Role]
WHERE FKGalleryId = @GalleryId AND RoleName = @RoleName
' 
END
GO
/****** Object:  StoredProcedure [gs_Role_AlbumInsert]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_AlbumInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_Role_AlbumInsert]
(
	@RoleName nvarchar(256), @AlbumId int
)
AS
SET NOCOUNT ON

INSERT {schema}[{objectQualifier}gs_Role_Album] (FKRoleName, FKAlbumId)
VALUES (@RoleName, @AlbumId)

RETURN
' 
END
GO
/****** Object:  StoredProcedure [gs_Role_AlbumDelete]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_AlbumDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_Role_AlbumDelete]
(
	@RoleName nvarchar(256), @AlbumId int
)
AS
SET NOCOUNT ON

DELETE FROM {schema}[{objectQualifier}gs_Role_Album]
WHERE FKRoleName = @RoleName AND FKAlbumId = @AlbumId

RETURN
' 
END
GO
/****** Object:  StoredProcedure [gs_AlbumInsert]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AlbumInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_AlbumInsert]
(@AlbumParentId int, @GalleryId int, @Title nvarchar(200), @DirectoryName nvarchar(255),
 @Summary nvarchar(1500), @ThumbnailMediaObjectId int, @Seq int, 
 @DateStart datetime, @DateEnd datetime, @CreatedBy nvarchar(256), @DateAdded datetime, 
 @LastModifiedBy nvarchar(256), @DateLastModified datetime, @OwnedBy nvarchar(256),
 @OwnerRoleName nvarchar(256), @IsPrivate bit, @Identity int OUT)
AS
/* Insert a new album. */
INSERT {schema}[{objectQualifier}gs_Album] (AlbumParentId, FKGalleryId, Title, DirectoryName, 
 Summary, ThumbnailMediaObjectId, Seq, DateStart, DateEnd, 
 CreatedBy, DateAdded, LastModifiedBy, DateLastModified, OwnedBy, 
 OwnerRoleName, IsPrivate)
VALUES (@AlbumParentId, @GalleryId, @Title, @DirectoryName, 
 @Summary, @ThumbnailMediaObjectId, @Seq, @DateStart, @DateEnd, 
 @CreatedBy, @DateAdded, @LastModifiedBy, @DateLastModified, @OwnedBy, 
 @OwnerRoleName, @IsPrivate)

SET @Identity = SCOPE_IDENTITY()' 
END
GO
/****** Object:  StoredProcedure [gs_MediaObjectSelect]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectSelect]
(
	@MediaObjectId int, @GalleryId int
)
AS
SET NOCOUNT ON

SELECT
	mo.MediaObjectId, mo.FKAlbumId, mo.Title, mo.HashKey, mo.ThumbnailFilename, mo.ThumbnailWidth, mo.ThumbnailHeight, 
	mo.ThumbnailSizeKB, mo.OptimizedFilename, mo.OptimizedWidth, mo.OptimizedHeight, mo.OptimizedSizeKB, 
	mo.OriginalFilename, mo.OriginalWidth, mo.OriginalHeight, mo.OriginalSizeKB, mo.ExternalHtmlSource, mo.ExternalType, mo.Seq, 
	mo.CreatedBy, mo.DateAdded, mo.LastModifiedBy, mo.DateLastModified, mo.IsPrivate
FROM {schema}[{objectQualifier}gs_MediaObject] mo JOIN {schema}[{objectQualifier}gs_Album] a ON mo.FKAlbumId = a.AlbumId
WHERE mo.MediaObjectId = @MediaObjectId AND a.FKGalleryId = @GalleryId

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_AlbumSelect]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AlbumSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_AlbumSelect]
(
	@AlbumId int
)
AS
SET NOCOUNT ON

SELECT
	AlbumId, FKGalleryId as GalleryId, AlbumParentId, Title, DirectoryName, Summary, ThumbnailMediaObjectId, 
	Seq, DateStart, DateEnd, CreatedBy, DateAdded, LastModifiedBy, DateLastModified, OwnedBy, OwnerRoleName, IsPrivate
FROM {schema}[{objectQualifier}gs_Album]
WHERE AlbumId = @AlbumId

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_GallerySelect]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_GallerySelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_GallerySelect]
(
	@GalleryId int
)
AS
SET NOCOUNT ON

SELECT GalleryId, Description, DateAdded
FROM {schema}[{objectQualifier}gs_Gallery]
WHERE GalleryId = @GalleryId

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_AlbumUpdate] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AlbumUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_AlbumUpdate]
(@AlbumId int, @AlbumParentId int, @Title nvarchar(200), @DirectoryName nvarchar(255),
 @Summary nvarchar(1500), @ThumbnailMediaObjectId int,  @Seq int, 
 @DateStart datetime, @DateEnd datetime, @LastModifiedBy nvarchar(256), 
 @DateLastModified datetime, @OwnedBy nvarchar(256), @OwnerRoleName nvarchar(256), @IsPrivate bit)
 
AS
SET NOCOUNT ON

UPDATE {schema}[{objectQualifier}gs_Album]
SET
	AlbumParentId = @AlbumParentId,
	Title = @Title,
	DirectoryName = @DirectoryName,
	Summary = @Summary,
	ThumbnailMediaObjectId = @ThumbnailMediaObjectId,
	Seq = @Seq,
	DateStart = @DateStart,
	DateEnd = @DateEnd,
	LastModifiedBy = @LastModifiedBy,
	DateLastModified = @DateLastModified,
	OwnedBy = @OwnedBy,
	OwnerRoleName = @OwnerRoleName,
	IsPrivate = @IsPrivate
WHERE (AlbumId = @AlbumId)

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_RoleSelect]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_RoleSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_RoleSelect]
(@GalleryId int)

AS
SET NOCOUNT ON

SELECT RoleName, AllowViewAlbumsAndObjects, AllowViewOriginalImage, AllowAddChildAlbum,
	AllowAddMediaObject, AllowEditAlbum, AllowEditMediaObject, AllowDeleteChildAlbum, 
	AllowDeleteMediaObject, AllowSynchronize, HideWatermark, AllowAdministerSite
FROM {schema}[{objectQualifier}gs_Role]
WHERE (FKGalleryId = @GalleryId)

RETURN
' 
END
GO
/****** Object:  StoredProcedure [gs_RoleInsert]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_RoleInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_RoleInsert]
(
	@GalleryId int, @RoleName nvarchar(256), @AllowViewAlbumsAndObjects bit, @AllowViewOriginalImage bit,
	@AllowAddChildAlbum bit, @AllowAddMediaObject bit, @AllowEditAlbum bit, @AllowEditMediaObject bit,
	@AllowDeleteChildAlbum bit, @AllowDeleteMediaObject bit, @AllowSynchronize bit, @HideWatermark bit,
	@AllowAdministerSite bit
)
AS
SET NOCOUNT ON

INSERT {schema}[{objectQualifier}gs_Role] (FKGalleryId, RoleName, AllowViewAlbumsAndObjects, AllowViewOriginalImage, AllowAddChildAlbum,
	AllowAddMediaObject, AllowEditAlbum, AllowEditMediaObject, AllowDeleteChildAlbum, AllowDeleteMediaObject, 
	AllowSynchronize, HideWatermark, AllowAdministerSite)
VALUES (@GalleryId, @RoleName, @AllowViewAlbumsAndObjects, @AllowViewOriginalImage, @AllowAddChildAlbum,
	@AllowAddMediaObject, @AllowEditAlbum, @AllowEditMediaObject, @AllowDeleteChildAlbum, @AllowDeleteMediaObject, 
	@AllowSynchronize, @HideWatermark, @AllowAdministerSite)

RETURN
' 
END
GO
/****** Object:  StoredProcedure [gs_MediaObjectUpdate]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectUpdate]
(
 @MediaObjectId int, @HashKey char(47), @FKAlbumId int, 
 @ThumbnailFilename nvarchar(255), @ThumbnailWidth int, @ThumbnailHeight int, @ThumbnailSizeKB int,
 @OriginalFilename nvarchar(255),	@OriginalWidth int, @OriginalHeight int, @OriginalSizeKB int, 
 @OptimizedFilename nvarchar(255),	@OptimizedWidth int, @OptimizedHeight int, @OptimizedSizeKB int, 
 @ExternalHtmlSource nvarchar(1000), @ExternalType nvarchar(15),
 @Title nvarchar(1000), @Seq int, @LastModifiedBy nvarchar(256), @DateLastModified datetime, @IsPrivate bit
)
AS
SET NOCOUNT ON

/* Update the media object. */
UPDATE {schema}[{objectQualifier}gs_MediaObject]
SET HashKey = @HashKey, FKAlbumId = @FKAlbumId,
 ThumbnailFilename = @ThumbnailFilename, ThumbnailWidth = @ThumbnailWidth, 
 ThumbnailHeight = @ThumbnailHeight, ThumbnailSizeKB = @ThumbnailSizeKB,
 OptimizedFilename = @OptimizedFilename, OptimizedWidth = @OptimizedWidth,
 OptimizedHeight = @OptimizedHeight, OptimizedSizeKB = @OptimizedSizeKB, 
 OriginalFilename = @OriginalFilename, OriginalWidth = @OriginalWidth,
 OriginalHeight = @OriginalHeight, OriginalSizeKB = @OriginalSizeKB, 
 ExternalHtmlSource = @ExternalHtmlSource, ExternalType = @ExternalType,
 Title = @Title, Seq = @Seq, LastModifiedBy = @LastModifiedBy, 
 DateLastModified = @DateLastModified, IsPrivate = @IsPrivate
WHERE MediaObjectId = @MediaObjectId' 
END
GO
/****** Object:  StoredProcedure [gs_SelectChildMediaObjects]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SelectChildMediaObjects]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_SelectChildMediaObjects]
(
	@AlbumId int
)
AS
SET NOCOUNT ON

SELECT 
	MediaObjectId, FKAlbumId, Title, HashKey, ThumbnailFilename, ThumbnailWidth, ThumbnailHeight, 
	ThumbnailSizeKB, OptimizedFilename, OptimizedWidth, OptimizedHeight, OptimizedSizeKB, 
	OriginalFilename, OriginalWidth, OriginalHeight, OriginalSizeKB, ExternalHtmlSource, ExternalType, Seq, 
	CreatedBy, DateAdded, LastModifiedBy, DateLastModified, IsPrivate
FROM {schema}[{objectQualifier}gs_MediaObject]
WHERE FKAlbumId = @AlbumId

RETURN' 
END
GO
/****** Object:  StoredProcedure [gs_MediaObjectInsert]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_MediaObjectInsert]
(@HashKey char(47), @FKAlbumId int, @ThumbnailFilename nvarchar(255), 
 @ThumbnailWidth int, @ThumbnailHeight int,
 @ThumbnailSizeKB int, @OptimizedFilename nvarchar(255), 
 @OptimizedWidth int, @OptimizedHeight int,
 @OptimizedSizeKB int, @OriginalFilename nvarchar(255),	 
 @OriginalWidth int, @OriginalHeight int, @OriginalSizeKB int, 
 @ExternalHtmlSource nvarchar(1000), @ExternalType nvarchar(15),
 @Title nvarchar(1000), @Seq int, @CreatedBy nvarchar(256), @DateAdded datetime, 
 @LastModifiedBy nvarchar(256), @DateLastModified datetime, @IsPrivate bit,
 @Identity int OUT)
AS

/* Insert media object information. */
 INSERT {schema}[{objectQualifier}gs_MediaObject] (HashKey, FKAlbumId, ThumbnailFilename, ThumbnailWidth, ThumbnailHeight,
 ThumbnailSizeKB, OptimizedFilename, OptimizedWidth, OptimizedHeight, OptimizedSizeKB,
 OriginalFilename, OriginalWidth, OriginalHeight, OriginalSizeKB, ExternalHtmlSource, ExternalType, Title, Seq, CreatedBy, 
 DateAdded, LastModifiedBy, DateLastModified, IsPrivate)
VALUES (@HashKey, @FKAlbumId, @ThumbnailFilename, @ThumbnailWidth, @ThumbnailHeight,
 @ThumbnailSizeKB, @OptimizedFilename, @OptimizedWidth, @OptimizedHeight, @OptimizedSizeKB,
 @OriginalFilename, @OriginalWidth, @OriginalHeight, @OriginalSizeKB, @ExternalHtmlSource, @ExternalType, @Title, @Seq, @CreatedBy, 
 @DateAdded, @LastModifiedBy, @DateLastModified, @IsPrivate)
 
SET @Identity = SCOPE_IDENTITY()' 
END
GO
/****** Object:  StoredProcedure [gs_SelectRootAlbum]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_SelectRootAlbum]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_SelectRootAlbum]
(
	@GalleryId int
)
AS
SET NOCOUNT ON

/* Return the root album. First, check to make sure it exists.
If not, call the stored proc that will insert a default record. */

IF NOT EXISTS (SELECT * FROM {schema}[{objectQualifier}gs_Album] WHERE AlbumParentId = 0 AND FKGalleryId = @GalleryId)
	EXEC {schema}[{objectQualifier}gs_VerifyMinimumRecords] @GalleryId

SELECT
	AlbumId, AlbumParentId, Title, DirectoryName, Summary, ThumbnailMediaObjectId, 
	Seq, DateStart, DateEnd, CreatedBy, DateAdded, LastModifiedBy, DateLastModified, OwnedBy, OwnerRoleName, IsPrivate
FROM {schema}[{objectQualifier}gs_Album]
WHERE AlbumParentId = 0 AND FKGalleryId = @GalleryId' 
END
GO
/****** Object:  StoredProcedure [gs_RoleUpdate]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_RoleUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_RoleUpdate] 
(
	@GalleryId int, @RoleName nvarchar(256), @AllowViewAlbumsAndObjects bit, @AllowViewOriginalImage bit,
	@AllowAddChildAlbum bit, @AllowAddMediaObject bit, @AllowEditAlbum bit, @AllowEditMediaObject bit,
	@AllowDeleteChildAlbum bit, @AllowDeleteMediaObject bit, @AllowSynchronize bit, @HideWatermark bit,
	@AllowAdministerSite bit
)
AS
SET NOCOUNT, XACT_ABORT ON

/* Update the specified role. If the role does not exist, assume it is new and call the insert proc. */
BEGIN TRAN
IF EXISTS (SELECT * FROM {schema}[{objectQualifier}gs_Role] WITH (UPDLOCK, HOLDLOCK) WHERE FKGalleryId = @GalleryId AND RoleName = @RoleName)
BEGIN
	UPDATE {schema}[{objectQualifier}gs_Role]
	SET AllowViewAlbumsAndObjects = @AllowViewAlbumsAndObjects,
		AllowViewOriginalImage = @AllowViewOriginalImage,
		AllowAddChildAlbum = @AllowAddChildAlbum,
		AllowAddMediaObject = @AllowAddMediaObject,
		AllowEditAlbum = @AllowEditAlbum,
		AllowEditMediaObject = @AllowEditMediaObject,
		AllowDeleteChildAlbum = @AllowDeleteChildAlbum,
		AllowDeleteMediaObject = @AllowDeleteMediaObject,
		AllowSynchronize = @AllowSynchronize,
		HideWatermark = @HideWatermark, 
		AllowAdministerSite = @AllowAdministerSite
	WHERE FKGalleryId = @GalleryId AND RoleName = @RoleName
END
ELSE
BEGIN
	EXECUTE {schema}[{objectQualifier}gs_RoleInsert] 
		@GalleryId,
		@RoleName,
		@AllowViewAlbumsAndObjects,
		@AllowViewOriginalImage,
		@AllowAddChildAlbum,
		@AllowAddMediaObject,
		@AllowEditAlbum,
		@AllowEditMediaObject,
		@AllowDeleteChildAlbum,
		@AllowDeleteMediaObject,
		@AllowSynchronize,
		@HideWatermark,
		@AllowAdministerSite
END
COMMIT

RETURN
' 
END
GO
/****** Object:  StoredProcedure [gs_AppErrorInsert] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppErrorInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_AppErrorInsert]
	(@GalleryId int, @TimeStamp datetime, @ExceptionType nvarchar (1000),
	@Message nvarchar (4000), @Source nvarchar (1000), @TargetSite nvarchar (max),
	@StackTrace nvarchar (max), @ExceptionData nvarchar (max), @InnerExType nvarchar (1000),
	@InnerExMessage nvarchar (4000), @InnerExSource nvarchar (1000), @InnerExTargetSite nvarchar (max),
	@InnerExStackTrace nvarchar (max), @InnerExData nvarchar (max), @Url nvarchar (1000),
	@FormVariables nvarchar (max), @Cookies nvarchar (max), @SessionVariables nvarchar (max),
	@ServerVariables nvarchar (max), @Identity int OUT)
AS

/* Insert a new application error. */
INSERT {schema}[{objectQualifier}gs_AppError]
  (FKGalleryId, [TimeStamp], ExceptionType, [Message], [Source], TargetSite, StackTrace, ExceptionData, InnerExType, 
  InnerExMessage, InnerExSource, InnerExTargetSite, InnerExStackTrace, InnerExData, Url, 
  FormVariables, Cookies, SessionVariables, ServerVariables)
VALUES (@GalleryId, @TimeStamp, @ExceptionType, @Message, @Source, @TargetSite, @StackTrace, @ExceptionData, @InnerExType, 
  @InnerExMessage, @InnerExSource, @InnerExTargetSite, @InnerExStackTrace, @InnerExData, @Url,
  @FormVariables, @Cookies, @SessionVariables, @ServerVariables)

SET @Identity = SCOPE_IDENTITY()

RETURN
' 
END
/****** Object:  StoredProcedure [gs_AppErrorSelect]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppErrorSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_AppErrorSelect]
(
	@GalleryId int
)
AS
SET NOCOUNT ON;

SELECT
  AppErrorId, FKGalleryId, [TimeStamp], ExceptionType, [Message], [Source], TargetSite, StackTrace, ExceptionData, 
  InnerExType, InnerExMessage, InnerExSource, InnerExTargetSite, InnerExStackTrace, InnerExData, Url, 
  FormVariables, Cookies, SessionVariables, ServerVariables
FROM {schema}[{objectQualifier}gs_AppError]
WHERE FKGalleryId = @GalleryId
' 
END
/****** Object:  StoredProcedure [gs_AppErrorDelete]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppErrorDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_AppErrorDelete]
(
	@AppErrorId int
)
AS
/* Delete application error */
DELETE {schema}[{objectQualifier}gs_AppError]
WHERE AppErrorId = @AppErrorId
' 
END
/****** Object:  StoredProcedure [gs_AppErrorDeleteAll]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppErrorDeleteAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC sp_executesql @statement = N'CREATE PROCEDURE {schema}[{objectQualifier}gs_AppErrorDeleteAll]
(
	@GalleryId int
)
AS
/* Delete all application errors for the gallery */
DELETE {schema}[{objectQualifier}gs_AppError]
WHERE FKGalleryId = @GalleryId
'
END
GO
/****** Object:  Default [DF_gs_Album_Title]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_Title]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_Album] ADD  CONSTRAINT [DF_{objectQualifier}gs_Album_Title]  DEFAULT ('') FOR [Title]

End
GO
/****** Object:  Default [DF_gs_Album_DirectoryName]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_DirectoryName]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_Album] ADD  CONSTRAINT [DF_{objectQualifier}gs_Album_DirectoryName]  DEFAULT ('') FOR [DirectoryName]

End
GO
/****** Object:  Default [DF_gs_Album_Summary]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_Summary]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_Album] ADD  CONSTRAINT [DF_{objectQualifier}gs_Album_Summary]  DEFAULT ('') FOR [Summary]

End
GO
/****** Object:  Default [DF_gs_Album_ThumbnailMediaObjectId]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_ThumbnailMediaObjectId]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_Album] ADD  CONSTRAINT [DF_{objectQualifier}gs_Album_ThumbnailMediaObjectId]  DEFAULT ((0)) FOR [ThumbnailMediaObjectId]

End
GO
/****** Object:  Default [DF_gs_Album_IsPrivate]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_Album_IsPrivate]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_Album] ADD  CONSTRAINT [DF_{objectQualifier}gs_Album_IsPrivate]  DEFAULT ((0)) FOR [IsPrivate]

End
GO
/****** Object:  Default [DF_gs_MediaObject_Title]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_Title]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_Title]  DEFAULT ('') FOR [Title]

End
GO
/****** Object:  Default [DF_gs_MediaObject_HashKey]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_HashKey]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_HashKey]  DEFAULT ('') FOR [HashKey]

End
GO
/****** Object:  Default [DF_gs_MediaObject_ThumbnailFilename]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_ThumbnailFilename]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_ThumbnailFilename]  DEFAULT ('') FOR [ThumbnailFilename]

End
GO
/****** Object:  Default [DF_gs_MediaObject_ThumbnailWidth]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_ThumbnailWidth]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_ThumbnailWidth]  DEFAULT ((0)) FOR [ThumbnailWidth]

End
GO
/****** Object:  Default [DF_gs_MediaObject_ThumbnailHeight]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_ThumbnailHeight]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_ThumbnailHeight]  DEFAULT ((0)) FOR [ThumbnailHeight]

End
GO
/****** Object:  Default [DF_gs_MediaObject_OptimizedFilename]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OptimizedFilename]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OptimizedFilename]  DEFAULT ('') FOR [OptimizedFilename]

End
GO
/****** Object:  Default [DF_gs_MediaObject_OptimizedWidth]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OptimizedWidth]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OptimizedWidth]  DEFAULT ((0)) FOR [OptimizedWidth]

End
GO
/****** Object:  Default [DF_gs_MediaObject_OptimizedHeight]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OptimizedHeight]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OptimizedHeight]  DEFAULT ((0)) FOR [OptimizedHeight]

End
GO
/****** Object:  Default [DF_gs_MediaObject_OriginalFilename]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OriginalFilename]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OriginalFilename]  DEFAULT ('') FOR [OriginalFilename]

End
GO
/****** Object:  Default [DF_gs_MediaObject_OriginalWidth]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OriginalWidth]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OriginalWidth]  DEFAULT ((0)) FOR [OriginalWidth]

End
GO
/****** Object:  Default [DF_gs_MediaObject_OriginalHeight]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_OriginalHeight]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD  CONSTRAINT [DF_{objectQualifier}gs_MediaObject_OriginalHeight]  DEFAULT ((0)) FOR [OriginalHeight]

End
GO
/****** Object:  Default [DF_gs_MediaObject_IsPrivate]  ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{schema}[DF_{objectQualifier}gs_MediaObject_IsPrivate]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
Begin
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] ADD CONSTRAINT [DF_{objectQualifier}gs_MediaObject_IsPrivate]  DEFAULT ((0)) FOR [IsPrivate]

End
GO
/****** Object:  ForeignKey [FK_gs_Album_gs_Album]  ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}FK_gs_Album_gs_Album]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Album] WITH CHECK ADD CONSTRAINT [FK_{objectQualifier}gs_Album_gs_Album] FOREIGN KEY([AlbumId])
REFERENCES {schema}[{objectQualifier}gs_Album] ([AlbumId])
GO
ALTER TABLE {schema}[{objectQualifier}gs_Album] CHECK CONSTRAINT [FK_{objectQualifier}gs_Album_gs_Album]
GO
/****** Object:  ForeignKey [FK_gs_Album_gs_Gallery]  ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}FK_gs_Album_gs_Gallery]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Album] WITH CHECK ADD CONSTRAINT [FK_{objectQualifier}gs_Album_gs_Gallery] FOREIGN KEY([FKGalleryId])
REFERENCES {schema}[{objectQualifier}gs_Gallery] ([GalleryId])
ON DELETE CASCADE
GO
ALTER TABLE {schema}[{objectQualifier}gs_Album] CHECK CONSTRAINT [FK_{objectQualifier}gs_Album_gs_Gallery]
GO
/****** Object:  ForeignKey [FK_gs_MediaObject_gs_Album]  ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}FK_gs_MediaObject_gs_Album]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObject]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] WITH CHECK ADD CONSTRAINT [FK_{objectQualifier}gs_MediaObject_gs_Album] FOREIGN KEY([FKAlbumId])
REFERENCES {schema}[{objectQualifier}gs_Album] ([AlbumId])
ON DELETE CASCADE
GO
ALTER TABLE {schema}[{objectQualifier}gs_MediaObject] CHECK CONSTRAINT [FK_{objectQualifier}gs_MediaObject_gs_Album]
GO
/****** Object:  ForeignKey [FK_gs_MediaObjectMetadata_gs_MediaObject]  ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}FK_gs_MediaObjectMetadata_gs_MediaObject]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_MediaObjectMetadata]'))
ALTER TABLE {schema}[{objectQualifier}gs_MediaObjectMetadata] WITH CHECK ADD CONSTRAINT [FK_{objectQualifier}gs_MediaObjectMetadata_gs_MediaObject] FOREIGN KEY([FKMediaObjectId])
REFERENCES {schema}[{objectQualifier}gs_MediaObject] ([MediaObjectId])
ON DELETE CASCADE
GO
ALTER TABLE {schema}[{objectQualifier}gs_MediaObjectMetadata] CHECK CONSTRAINT [FK_{objectQualifier}gs_MediaObjectMetadata_gs_MediaObject]
GO
/****** Object:  ForeignKey [FK_gs_Role_Album_gs_Album]  ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}FK_gs_Role_Album_gs_Album]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_Role_Album]'))
ALTER TABLE {schema}[{objectQualifier}gs_Role_Album] WITH CHECK ADD CONSTRAINT [FK_{objectQualifier}gs_Role_Album_gs_Album] FOREIGN KEY([FKAlbumId])
REFERENCES {schema}[{objectQualifier}gs_Album] ([AlbumId])
GO
ALTER TABLE {schema}[{objectQualifier}gs_Role_Album] CHECK CONSTRAINT [FK_{objectQualifier}gs_Role_Album_gs_Album]
GO
/****** Object:  ForeignKey [FK_gs_AppError_gs_Gallery]   ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{schema}[{objectQualifier}FK_gs_AppError_gs_Gallery]') AND parent_object_id = OBJECT_ID(N'{schema}[{objectQualifier}gs_AppError]'))
ALTER TABLE {schema}[{objectQualifier}gs_AppError] WITH CHECK ADD CONSTRAINT [FK_{objectQualifier}gs_AppError_gs_Gallery] FOREIGN KEY([FKGalleryId])
REFERENCES {schema}[{objectQualifier}gs_Gallery] ([GalleryId])
ON DELETE CASCADE
GO
ALTER TABLE {schema}[{objectQualifier}gs_AppError] CHECK CONSTRAINT [FK_{objectQualifier}gs_AppError_gs_Gallery]
GO

/**********************************************************************/
/*                             END SECTION 2                          */
/**********************************************************************/

/**********************************************************************/
/*                          BEGIN SECTION 3                           */
/*
Create database role and configure permissions for this role. Then later
all we have to do is add the desired SQL user to this role. This script was manually
generated. */
/**********************************************************************/

/* Create SQL role that will have permission to execute Gallery Server related objects */
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'{objectQualifier}gs_GalleryServerProRole' AND type = 'R')
CREATE ROLE {objectQualifier}gs_GalleryServerProRole
GO

/* Grant permission to SQL role. */
GRANT EXECUTE ON {schema}[{objectQualifier}gs_AlbumDelete] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_AlbumInsert] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_AlbumSelect] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_AlbumUpdate] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_GallerySelect] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectDelete] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectInsert] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectMetadataDelete] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectMetadataDeleteByMediaObjectId] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectMetadataInsert] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectMetadataSelect] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectMetadataUpdate] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectSelect] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectSelectHashKeys] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_MediaObjectUpdate] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_Role_AlbumDelete] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_Role_AlbumInsert] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_Role_AlbumSelectAllAlbumsByRoleName] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_Role_AlbumSelectRootAlbumsByRoleName] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_RoleDelete] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_RoleInsert] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_RoleSelect] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_RoleUpdate] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_AppErrorSelect] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_AppErrorInsert] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_AppErrorDelete] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_AppErrorDeleteAll] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_SearchGallery] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_SelectChildAlbums] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_SelectChildMediaObjects] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_SelectRootAlbum] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_SynchronizeSave] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_SynchronizeSelect] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_VerifyMinimumRecords] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT SELECT ON {schema}[{objectQualifier}gs_func_convert_string_array_to_table] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_GetVersion] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_ExportMembership] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_ExportGalleryData] TO [{objectQualifier}gs_GalleryServerProRole]
GO
GRANT EXECUTE ON {schema}[{objectQualifier}gs_DeleteData] TO [{objectQualifier}gs_GalleryServerProRole]
GO

/**********************************************************************/
/*                          END SECTION 3                             */
/**********************************************************************/

/**********************************************************************/
/*                             BEGIN SECTION 4                        */
/*
   Add ASP.NET roles to GSP role (gs_GalleryServerProRole).
   NOTE: Do not include this section in DotNetNuke module!            */
/**********************************************************************/
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aspnet_Membership_BasicAccess')
	EXEC sys.sp_addrolemember @rolename=N'aspnet_Membership_BasicAccess', @membername=N'{objectQualifier}gs_GalleryServerProRole'
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aspnet_Membership_FullAccess')
	EXEC sys.sp_addrolemember @rolename=N'aspnet_Membership_FullAccess', @membername=N'{objectQualifier}gs_GalleryServerProRole'
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aspnet_Membership_ReportingAccess')
	EXEC sys.sp_addrolemember @rolename=N'aspnet_Membership_ReportingAccess', @membername=N'{objectQualifier}gs_GalleryServerProRole'
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aspnet_Profile_BasicAccess')
	EXEC sys.sp_addrolemember @rolename=N'aspnet_Profile_BasicAccess', @membername=N'{objectQualifier}gs_GalleryServerProRole'
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aspnet_Profile_FullAccess')
	EXEC sys.sp_addrolemember @rolename=N'aspnet_Profile_FullAccess', @membername=N'{objectQualifier}gs_GalleryServerProRole'
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aspnet_Profile_ReportingAccess')
	EXEC sys.sp_addrolemember @rolename=N'aspnet_Profile_ReportingAccess', @membername=N'{objectQualifier}gs_GalleryServerProRole'
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aspnet_Roles_BasicAccess')
	EXEC sys.sp_addrolemember @rolename=N'aspnet_Roles_BasicAccess', @membername=N'{objectQualifier}gs_GalleryServerProRole'
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aspnet_Roles_FullAccess')
	EXEC sys.sp_addrolemember @rolename=N'aspnet_Roles_FullAccess', @membername=N'{objectQualifier}gs_GalleryServerProRole'
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aspnet_Roles_ReportingAccess')
	EXEC sys.sp_addrolemember @rolename=N'aspnet_Roles_ReportingAccess', @membername=N'{objectQualifier}gs_GalleryServerProRole'
GO