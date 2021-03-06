﻿CREATE TABLE [dbo].[TAP8_WFM_QUERY_BUTTONS] (
    [CD_QUERY]       INT          NOT NULL,
    [CD_BUTTON]      INT          NOT NULL,
    [CD_PROCESO]     VARCHAR (20) NULL,
    [SN_SINCRONIZAR] VARCHAR (2)  CONSTRAINT [DF_TAP8_WFM_QUERY_BUTTONS_SN_SINCRONIZAR] DEFAULT ('SI') NULL,
    [CD_PROYECTO]    VARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([CD_QUERY] ASC, [CD_BUTTON] ASC),
    FOREIGN KEY ([CD_QUERY]) REFERENCES [dbo].[TAP8_WFM_QUERY] ([CD_QUERY]),
    CONSTRAINT [FK__TAP8_WFM___CD_BU__534D60F1] FOREIGN KEY ([CD_BUTTON]) REFERENCES [dbo].[TAP8_WFM_BUTTON] ([CD_BUTTON])
);


GO
ALTER TABLE [dbo].[TAP8_WFM_QUERY_BUTTONS] NOCHECK CONSTRAINT [FK__TAP8_WFM___CD_BU__534D60F1];

