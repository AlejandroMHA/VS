﻿CREATE TABLE [dbo].[TAP8_WFM_BUTTON] (
    [CD_BUTTON]      INT            NOT NULL,
    [CD_NAME]        VARCHAR (50)   NOT NULL,
    [DS_LABEL]       VARCHAR (50)   NULL,
    [DS_ICON_CLS]    VARCHAR (50)   NULL,
    [DS_TOOLTIP]     VARCHAR (200)  NULL,
    [DS_CONFIG]      VARCHAR (3072) NULL,
    [DS_SCRIPT]      VARCHAR (MAX)  NULL,
    [CD_PROCESO]     VARCHAR (20)   NULL,
    [SN_SINCRONIZAR] VARCHAR (2)    CONSTRAINT [DF_TAP8_WFM_BUTTON_SN_SINCRONIZAR] DEFAULT ('SI') NULL,
    [CD_PROYECTO]    VARCHAR (10)   NULL,
    CONSTRAINT [PK__TAP8_WFM__CD80E58B4CA06362] PRIMARY KEY CLUSTERED ([CD_BUTTON] ASC)
);

