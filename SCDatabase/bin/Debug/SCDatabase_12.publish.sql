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
PRINT N'Creating [SCCatalog].[SecreteQuestionMaster]...';


GO
CREATE TABLE [SCCatalog].[SecreteQuestionMaster] (
    [QuestionId]     INT            IDENTITY (100, 1) NOT NULL,
    [Question]       NVARCHAR (MAX) NOT NULL,
    [QuestionHint]   NCHAR (10)     NULL,
    [CreateDatetime] DATETIME       NOT NULL,
    [UpdateDatetime] DATETIME       NOT NULL,
    PRIMARY KEY CLUSTERED ([QuestionId] ASC)
);


GO
PRINT N'Creating [SCCatalog].[UserProfile]...';


GO
CREATE TABLE [SCCatalog].[UserProfile] (
    [UserId]           INT            NOT NULL,
    [Legal_First_Name] NVARCHAR (100) NOT NULL,
    [Legal_last_Name]  NVARCHAR (100) NULL,
    [EmailAddress]     NVARCHAR (100) NOT NULL,
    [Address]          NVARCHAR (500) NULL,
    [CreateDatetime]   DATETIME       NOT NULL,
    [UpdateDatetime]   DATETIME       NOT NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC)
);


GO
PRINT N'Creating [SCCatalog].[UserSecreteMap]...';


GO
CREATE TABLE [SCCatalog].[UserSecreteMap] (
    [UserId]            INT            NOT NULL,
    [SecreteQuestionId] INT            NOT NULL,
    [Answer]            NVARCHAR (MAX) NOT NULL,
    [CreateDatetime]    DATETIME       NOT NULL,
    [UpdateDatetime]    DATETIME       NOT NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC, [SecreteQuestionId] ASC)
);


GO
PRINT N'Update complete.';


GO
