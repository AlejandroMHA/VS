﻿CREATE PROCEDURE [dbo].[SP_SINCRONIZAR_HAMBIENTES]

as


DECLARE @Proceso varchar(20), @BdInsert varchar(50), @BdSelect varchar(50), @Sql varchar(2000)

SET @BdInsert = 'InspectorDB'
SET @BdSelect = 'DBInspectorVictor'

SET @Sql = 
'INSERT INTO ' +  @BdInsert + '.dbo.TAP8_DSGR_SCREEN ' + 
'(CD_NAME, DS_JSON, CD_INITBUTTON, DS_CONFIG )' +
'SELECT CD_NAME, DS_JSON, CD_INITBUTTON, DS_CONFIG FROM ' + @BdSelect + '.dbo.TAP8_DSGR_SCREEN 
WHERE SN_SINCRONIZAR = ' + '''' + 'SI' + ''''

--EXEC sp_sqlexec @Sql

SET @Sql = 
'INSERT INTO ' +  @BdInsert + '.dbo.TAP8_DSGR_FIELD ' + 
'(CD_FIELD, DS_NAME, DS_LABEL, DS_TYPE, DS_DEPENDFIELDNAMES, DS_SCRIPT, DS_CONFIG )' +
'SELECT CD_FIELD, DS_NAME, DS_LABEL, DS_TYPE, DS_DEPENDFIELDNAMES, DS_SCRIPT, DS_CONFIG
 FROM ' + @BdSelect + '.dbo.TAP8_DSGR_FIELD ' 

-- EXEC sp_sqlexec @Sql

SET @Sql = 
'INSERT INTO ' +  @BdInsert + '.dbo.TAP8_GRIDS_GRID ' + 
'(CD_GRID, CD_NAME, DS_TITLE, DS_DATASCRIPT, DS_FIELDS, DS_COLUMNS, DS_CONFIG, DS_DETAILCONFIG, DS_DESCRIPTION )' +
'SELECT CD_GRID, CD_NAME, DS_TITLE, DS_DATASCRIPT, DS_FIELDS, DS_COLUMNS, DS_CONFIG, DS_DETAILCONFIG, DS_DESCRIPTION
 FROM ' + @BdSelect + '.dbo.TAP8_GRIDS_GRID WHERE SN_SINCRONIZAR = ' + '''' + 'SI' + '''' 

 --EXEC sp_sqlexec @Sql


SET @Sql = 
'INSERT INTO ' +  @BdInsert + '.dbo.TAP8_WFM_BUTTON ' + 
'(CD_BUTTON, CD_NAME, DS_LABEL, DS_ICON_CLS, DS_TOOLTIP, DS_SCRIPT, DS_CONFIG)' +
'SELECT CD_BUTTON, CD_NAME, DS_LABEL, DS_ICON_CLS, DS_TOOLTIP, DS_SCRIPT, DS_CONFIG
 FROM ' + @BdSelect + '.dbo.TAP8_WFM_BUTTON WHERE SN_SINCRONIZAR = ' + '''' + 'SI' + '''' 


 EXEC sp_sqlexec @Sql
 
--SELECT * FROM TAP8_WFM_BUTTON





