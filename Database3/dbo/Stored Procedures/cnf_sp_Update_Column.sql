CREATE  PROCEDURE [dbo].[cnf_sp_Update_Column] (
@IdProyecto				varchar(10) out,
@CD_DATASOURCE			int out,
@CD_COLUMN				int out,
@CD_NAME				varchar(100) out,
@CD_DATA_TYPE			varchar(20) out,
@DS_DESCRIPTION			varchar(200) out,
@DS_CONFIG				varchar(max) out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int, @UltimoId int

SET @Mensaje = ''

IF @IdProyecto = '' BEGIN
	SET @Mensaje = @Mensaje + 'Debe seleccionar un proyecto para poder agregar la columna'
	RETURN
END

IF @CD_DATASOURCE = 0 BEGIN
	SET @Mensaje = @Mensaje + 'DEBE SELECCIONAR EL DATA SOURCE DE LA COLUMNA QUE DESEA ACTUALIZAR'
	RETURN
END

IF @CD_COLUMN = 0 BEGIN
	SET @Mensaje = @Mensaje + 'DEBE SELECCIONAR LA COLUMNA A ACTUALIZAR'
	RETURN
END

IF @CD_NAME = '' OR @DS_DESCRIPTION = '' OR @CD_DATA_TYPE = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Nombre, La Descripción y El Tipo de Dato son obligatorio'
	RETURN
END


SELECT @UltimoId = UltimoId  + 1 FROM LPA_InspectorWEB_DB.dbo.TD_PROYECTOS WHERE IdProyecto = @IdProyecto


SELECT @Conta = COUNT(*) FROM TAP8_WFM_COLUMN WHERE CD_COLUMN = @CD_COLUMN

IF @Conta = 0 BEGIN
	SET @Mensaje = @Mensaje + 'No hay ninguna columna seleccionada para Eliminar'
	RETURN
END



UPDATE TAP8_WFM_COLUMN SET
	CD_PROYECTO			= @IdProyecto,
	CD_NAME				= @CD_NAME,
	CD_DATA_TYPE		= @CD_DATA_TYPE,
	DS_DESCRIPTION		= @DS_DESCRIPTION,
	DS_CONFIG			= RTRIM(@DS_CONFIG)
WHERE
	CD_COLUMN = @CD_COLUMN



