CREATE  PROCEDURE [dbo].[cnf_sp_Update_DataSource] (
@IdProyecto				varchar(10) out,
@CD_DATASOURCE			int out,
@CD_OWNER				varchar(50) out,
@DS_DESCRIPTION			varchar(200) out,
@CD_NAME				varchar(100) out,
@CD_CONTEXT				int out,
@DS_CONFIG				varchar(max) out,
@DS_SQL					varchar(max) out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int, @UltimoId int


SET @Mensaje = ''

IF @IdProyecto = '' BEGIN
	SET @Mensaje = @Mensaje + 'Debe seleccionar un proyecto para poder modificar el Data Source'
	RETURN
END

IF @CD_DATASOURCE = 0 BEGIN
	SET @Mensaje = @Mensaje + 'DEBE SELECCIONAR EL DATA SOURCE QUE QUIERE ACTUALIZAR'
	RETURN
END

IF @CD_NAME = '' OR @CD_OWNER = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Nombre, y el Tipo de Fuente es obligatorio'
	RETURN
END

UPDATE TAP8_WFM_DATASOURCE SET 
	CD_PROYECTO			= @IdProyecto,
	CD_OWNER			= @CD_OWNER,
	DS_DESCRIPTION		= @DS_DESCRIPTION,
	CD_NAME				= @CD_NAME,
	CD_CONTEXT			= @CD_CONTEXT
WHERE 	
CD_DATASOURCE = @CD_DATASOURCE
	
UPDATE TAP8_WFM_QUERY SET
	CD_PROYECTO			= @IdProyecto,
	DS_DESCRIPTION		= @DS_DESCRIPTION,
	CD_NAME				= @CD_NAME,
	DS_CONFIG			= RTRIM(@DS_CONFIG),	
	DS_SQL				= RTRIM(@DS_SQL)
WHERE 	
CD_QUERY = @CD_DATASOURCE

UPDATE TAP8_WFM_DATASOURCE_QUERY SET 	
CD_PROYECTO	= @IdProyecto
WHERE 	
CD_DATASOURCE = @CD_DATASOURCE



