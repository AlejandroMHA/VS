CREATE  PROCEDURE [dbo].[cnf_sp_Update_Grid] (
@CD_GRID					int out,
@CD_NAME					varchar(64) out,			
@DS_TITLE					varchar(128) out,
@DS_DATASCRIPT				varchar(1024) out,
@DS_FIELDS					varchar(512) out,
@DS_COLUMNS					varchar(4024) out,
@DS_CONFIG					varchar(4024) out,
@Mensaje					varchar(500) out
)

as

DECLARE @Conta int

IF @CD_GRID = 0 BEGIN
	SET @Mensaje = 'No ha seleccionado un Grid para Actualizar. Falta el Id. del Grid'
	RETURN
END

IF @CD_NAME = '' OR @DS_TITLE = '' BEGIN
	SET @Mensaje = 'El nombre del Grid y el título son obligatorios.'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_GRIDS_GRID WHERE CD_NAME = @CD_NAME AND CD_GRID <> @CD_GRID

IF @Conta > 0 BEGIN
	SET @Mensaje = 'Ya existe otro Grid con el mismo Nonmbre dentro del Proyecto'
	RETURN
END


UPDATE TAP8_GRIDS_GRID SET
	CD_NAME				= @CD_NAME,		
	DS_TITLE			= @DS_TITLE, 
	DS_DATASCRIPT		= RTRIM(@DS_DATASCRIPT),
	DS_FIELDS			= RTRIM(@DS_FIELDS),
	DS_COLUMNS			= RTRIM(@DS_COLUMNS),
	DS_CONFIG			= RTRIM(@DS_CONFIG)
WHERE
	CD_GRID = @CD_GRID



