CREATE  PROCEDURE [dbo].[cnf_sp_Update_Field] (
@CD_FIELD 				int out,
@DS_NAME				varchar(64) out,
@DS_LABEL				varchar(64) out,
@DS_TYPE				varchar(16) out,
@DS_DEPENDFIELDNAMES	varchar(128) out,
@DS_SCRIPT				varchar(1024) out,
@DS_CONFIG				varchar(1024) out,
@Mensaje				varchar(500) out
)

as

DECLARE  @Conta int, @UltimoId int


SET @Mensaje = ''

IF @CD_FIELD = 0 BEGIN
	SET @Mensaje = @Mensaje + 'DEBE SELECCIONAR EL FIELD A MODIFICAR'
	RETURN
END

IF @DS_NAME = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Nombre es obligatorio'
	RETURN
END

UPDATE TAP8_DSGR_FIELD SET
	DS_NAME					= @DS_NAME,				
	DS_LABEL				= @DS_LABEL,				
	DS_TYPE					= @DS_TYPE,				
	DS_DEPENDFIELDNAMES		= LTRIM(@DS_DEPENDFIELDNAMES),	
	DS_SCRIPT				= LTRIM(@DS_SCRIPT),				
	DS_CONFIG				= LTRIM(@DS_CONFIG)	
WHERE 
	CD_FIELD = @CD_FIELD



