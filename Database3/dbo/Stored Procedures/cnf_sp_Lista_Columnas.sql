﻿CREATE  PROCEDURE [dbo].[cnf_sp_Lista_Columnas] (
@IdProyecto 				varchar(10) out,
@CD_DATASOURCE				int out
)

as

IF @IdProyecto = '' OR @CD_DATASOURCE = 0
	RETURN

SELECT 
	CD_COLUMN,
	CD_NAME,		
	CD_DATA_TYPE,
	DS_DESCRIPTION,
	DS_CONFIG + ' ' as DS_CONFIG 
FROM TAP8_WFM_COLUMN
WHERE CD_PROYECTO LIKE @IdProyecto AND CD_COLUMN NOT IN (SELECT CD_COLUMN FROM TAP8_WFM_QUERY_COLUMNS WHERE CD_QUERY = @CD_DATASOURCE)
ORDER BY CD_NAME

-- EXEC cnf_sp_Lista_Columnas_DataSource '_LPAConfig',



