CREATE  PROCEDURE [dbo].[cnf_sp_Lista_Grid] (
@IdProyecto 				varchar(10) out
)

as

IF @IdProyecto = ''
	RETURN

SELECT 
	CD_GRID,
	CD_NAME,		
	DS_TITLE,
	DS_DATASCRIPT,
	DS_FIELDS + ' ' as DS_FIELDS,
	DS_COLUMNS + ' ' as DS_COLUMNS,
	DS_CONFIG + ' ' as DS_CONFIG
FROM TAP8_GRIDS_GRID 
WHERE CD_PROYECTO LIKE @IdProyecto



