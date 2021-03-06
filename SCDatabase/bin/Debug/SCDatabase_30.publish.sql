﻿/*
Deployment script for SCCatalog

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar SCSqlServicePassword "G00dne$$01"
:setvar DatabaseName "SCCatalog"
:setvar DefaultFilePrefix "SCCatalog"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [SCCatalog].[UserProfile].[PGuid] on table [SCCatalog].[UserProfile] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [SCCatalog].[UserProfile])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping [SCCatalog].[FK_Ticket_UserProfile]...';


GO
ALTER TABLE [SCCatalog].[Ticket] DROP CONSTRAINT [FK_Ticket_UserProfile];


GO
PRINT N'Dropping [SCCatalog].[FK_TicketCommentMapping_UserProfile]...';


GO
ALTER TABLE [SCCatalog].[TicketCommentMapping] DROP CONSTRAINT [FK_TicketCommentMapping_UserProfile];


GO
PRINT N'Starting rebuilding table [SCCatalog].[UserProfile]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [SCCatalog].[tmp_ms_xx_UserProfile] (
    [UserId]           INT            NOT NULL,
    [PGuid]            NVARCHAR (100) NOT NULL,
    [Legal_First_Name] NVARCHAR (100) NOT NULL,
    [Legal_last_Name]  NVARCHAR (100) NULL,
    [EmailAddress]     NVARCHAR (100) NOT NULL,
    [Address]          NVARCHAR (500) NULL,
    [PassoutBatch]     INT            NULL,
    [Dept]             NVARCHAR (50)  NULL,
    [CreateDatetime]   DATETIME       NOT NULL,
    [UpdateDatetime]   DATETIME       NOT NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [SCCatalog].[UserProfile])
    BEGIN
        INSERT INTO [SCCatalog].[tmp_ms_xx_UserProfile] ([UserId], [Legal_First_Name], [Legal_last_Name], [EmailAddress], [Address], [PassoutBatch], [Dept], [CreateDatetime], [UpdateDatetime])
        SELECT   [UserId],
                 [Legal_First_Name],
                 [Legal_last_Name],
                 [EmailAddress],
                 [Address],
                 [PassoutBatch],
                 [Dept],
                 [CreateDatetime],
                 [UpdateDatetime]
        FROM     [SCCatalog].[UserProfile]
        ORDER BY [UserId] ASC;
    END

DROP TABLE [SCCatalog].[UserProfile];

EXECUTE sp_rename N'[SCCatalog].[tmp_ms_xx_UserProfile]', N'UserProfile';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [SCCatalog].[FK_Ticket_UserProfile]...';


GO
ALTER TABLE [SCCatalog].[Ticket] WITH NOCHECK
    ADD CONSTRAINT [FK_Ticket_UserProfile] FOREIGN KEY ([CreatedByUserId]) REFERENCES [SCCatalog].[UserProfile] ([UserId]);


GO
PRINT N'Creating [SCCatalog].[FK_TicketCommentMapping_UserProfile]...';


GO
ALTER TABLE [SCCatalog].[TicketCommentMapping] WITH NOCHECK
    ADD CONSTRAINT [FK_TicketCommentMapping_UserProfile] FOREIGN KEY ([UserId]) REFERENCES [SCCatalog].[UserProfile] ([UserId]);


GO
PRINT N'Refreshing [SCCatalog].[spUpsertUser]...';


GO
EXECUTE sp_refreshsqlmodule N'[SCCatalog].[spUpsertUser]';


GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

PRINT N'******************************************************************************'
PRINT N'Populating valid values for Secreate question...'

DECLARE @CurrentDatetime datetime,
@TransactionIsOurs int

DECLARE @LoadValues TABLE 
(
	CategoryId INT,
	Category_Desc NVARCHAR(MAX),
	CreateDatetime Datetime,
	UpdateDatetime Datetime
)

BEGIN TRANSACTION
SET @CurrentDatetime = getutcdate()
SET @TransactionIsOurs = 1

INSERT INTO @LoadValues(CategoryId, Category_Desc, CreateDatetime, UpdateDatetime)
Values
(1, 'Cat 1', @CurrentDatetime, @CurrentDatetime),
(2, 'Cat 2', @CurrentDatetime, @CurrentDatetime),
(3, 'Cat 3', @CurrentDatetime, @CurrentDatetime),
(4, 'Cat 4', @CurrentDatetime, @CurrentDatetime)

SET IDENTITY_INSERT [SCCatalog].[TicketCategoryMaster] ON
MERGE SCCatalog.TicketCategoryMaster TC
USING @LoadValues lv
ON (TC.Category_Description = lv.Category_Desc)
WHEN MATCHED THEN
	UPDATE SET
	--SM.[QuestionId] = lv.QuestionId,
	--SM.[Question] = lv.Question,
	--SM.[QuestionHint] = lv.QuestionHint,
	TC.[CreateDatetime] = lv.CreateDatetime,
	TC.[UpdateDatetime] = lv.UpdateDatetime

WHEN NOT MATCHED BY TARGET THEN
	INSERT
	(
		[CategoryId],
		[Category_Description],
		[CreateDatetime],
		[UpdateDatetime]
	)
	VALUES
	(
		lv.CategoryId,
		lv.Category_Desc,
		lv.CreateDatetime,
		lv.UpdateDatetime
	)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
OUTPUT $action,
inserted.CategoryId as AddedCategoryId,
deleted.CategoryId as deletedCategoryId;

SET IDENTITY_INSERT SCCatalog.TicketCategoryMaster OFF

IF @@ERROR <> 0 GOTO error_label

COMMIT TRANSACTION

SET @TransactionIsOurs = 0

error_label:
	IF @TransactionIsOurs = 1
	BEGIN
        RAISERROR(N'ERROR populating values TicketCategoryMaster table', 16, 1)
        ROLLBACK TRANSACTION
	END
GO


GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [SCCatalog].[Ticket] WITH CHECK CHECK CONSTRAINT [FK_Ticket_UserProfile];

ALTER TABLE [SCCatalog].[TicketCommentMapping] WITH CHECK CHECK CONSTRAINT [FK_TicketCommentMapping_UserProfile];


GO
PRINT N'Update complete.';


GO
