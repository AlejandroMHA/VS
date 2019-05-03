﻿CREATE TABLE [dbo].[TAP8_GRIDS_GRID] (
    [CD_GRID]         INT           NOT NULL,
    [CD_NAME]         VARCHAR (64)  NOT NULL,
    [DS_TITLE]        VARCHAR (128) NOT NULL,
    [DS_DATASCRIPT]   VARCHAR (MAX) NULL,
    [DS_FIELDS]       VARCHAR (MAX) NULL,
    [DS_COLUMNS]      VARCHAR (MAX) NULL,
    [DS_CONFIG]       VARCHAR (MAX) NULL,
    [DS_DETAILCONFIG] VARCHAR (MAX) NULL,
    [DS_DESCRIPTION]  VARCHAR (256) NULL,
    [CD_PROCESO]      VARCHAR (20)  NULL,
    [SN_SINCRONIZAR]  VARCHAR (2)   CONSTRAINT [DF_TAP8_GRIDS_GRID_SN_SINCRONIZAR] DEFAULT ('SI') NULL,
    [CD_PROYECTO]     VARCHAR (10)  NULL,
    PRIMARY KEY CLUSTERED ([CD_GRID] ASC)
);
